"""OBD fault-detection service.

Responsible for:
  - Loading the trained RandomForest model, label encoder, and feature list
    **once** at application startup.
  - Accepting an aggregated feature dictionary and returning the top-N
    predicted faults with confidence scores.

This module does NOT know about HTTP, CSV parsing, or the NLP pipeline.
"""

from __future__ import annotations

import logging
import os
import time
from pathlib import Path
from typing import Any, Dict, List

import joblib

logger = logging.getLogger(__name__)


class OBDModelLoadError(Exception):
    """Raised when the OBD model API fails."""


class OBDService:
    """Singleton-style service that wraps the OBD locally parsed RandomForest model."""

    def __init__(self, model_dir: str | Path | None = None) -> None:
        """Initialize the model natively via joblib.

        Parameters
        ----------
        model_dir : str | Path | None
            Ignored. Overridden by explicit structure definitions
        """
        MODEL_DIR = os.path.join(os.path.dirname(__file__), "../../models")
        # Ensure we bind correctly to backend/models/obd rather than root/models
        # based on context, root is ../../
        root_path = Path(__file__).resolve().parent.parent.parent
        obd_model_dir = root_path / "models" / "obd"
        
        try:
            self.model = joblib.load(obd_model_dir / "obd_rf_model.joblib")
            self.features = joblib.load(obd_model_dir / "obd_features.joblib")
            self.label_encoder = joblib.load(obd_model_dir / "obd_label_encoder.joblib")
            logger.info("Local OBD service configured successfully natively via joblib.")
        except Exception as exc:
            raise OBDModelLoadError(f"Local OBD Model artifacts failed to load: {exc}") from exc

    # ── Public API ─────────────────────────────────────────────────────
    def predict_top_faults(
        self,
        feature_dict: Dict[str, float],
        top_n: int = 3,
    ) -> List[Dict[str, Any]]:
        """Return the *top_n* most likely faults with confidence scores via Local RandomForest.

        Parameters
        ----------
        feature_dict : dict[str, float]
            Aggregated OBD features keyed by feature name.
        top_n : int
            Number of top predictions to return (default 3).

        Returns
        -------
        list[dict]
            Each dict contains ``fault`` (str) and ``confidence`` (float),
            sorted by descending confidence.
        """
        start = time.time()
        
        feature_vector = [feature_dict[f] for f in self.features]
        
        probabilities = self.model.predict_proba([feature_vector])[0]
        end = time.time()
        
        print("OBD Inference Time:", (end - start) * 1000, "ms")

        label_probs = sorted(
            zip(self.label_encoder.classes_, probabilities),
            key=lambda pair: pair[1],
            reverse=True,
        )

        return [
            {"fault": str(label), "confidence": round(float(prob), 4)}
            for label, prob in label_probs[:top_n]
        ]