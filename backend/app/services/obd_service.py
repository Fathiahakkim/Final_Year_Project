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
from pathlib import Path
from typing import Any, Dict, List

import joblib
import numpy as np

logger = logging.getLogger(__name__)


class OBDModelLoadError(Exception):
    """Raised when the OBD model artifacts fail to load."""


class OBDService:
    """Singleton-style service that wraps the OBD RandomForest model."""

    def __init__(self, model_dir: str | Path | None = None) -> None:
        """Load model artifacts from *model_dir*.

        Parameters
        ----------
        model_dir : str | Path | None
            Directory that contains ``obd_rf_model.joblib``,
            ``obd_label_encoder.joblib``, and ``obd_features.joblib``.
            Defaults to ``<project_root>/models/obd/``.
        """
        if model_dir is None:
            model_dir = (
                Path(__file__).resolve().parent.parent.parent / "models" / "obd"
            )
        else:
            model_dir = Path(model_dir)

        model_path = model_dir / "obd_rf_model.joblib"
        encoder_path = model_dir / "obd_label_encoder.joblib"
        features_path = model_dir / "obd_features.joblib"

        try:
            self.model: Any = joblib.load(model_path)
            self.label_encoder: Any = joblib.load(encoder_path)
            self.feature_list: List[str] = joblib.load(features_path)
            logger.info(
                "OBD model loaded — %d features, %d classes",
                len(self.feature_list),
                len(self.label_encoder.classes_),
            )
        except FileNotFoundError as exc:
            raise OBDModelLoadError(
                f"OBD model artifact not found: {exc}"
            ) from exc
        except Exception as exc:
            raise OBDModelLoadError(
                f"Failed to load OBD model artifacts: {exc}"
            ) from exc

    # ── Public API ─────────────────────────────────────────────────────
    def predict_top_faults(
        self,
        feature_dict: Dict[str, float],
        top_n: int = 3,
    ) -> List[Dict[str, Any]]:
        """Return the *top_n* most likely faults with confidence scores.

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
        # Build feature vector in the order the model was trained on
        X = np.array([[feature_dict[f] for f in self.feature_list]])

        import time
        start = time.time()
        probabilities = self.model.predict_proba(X)[0]
        end = time.time()
        print("OBD Inference Time:", (end - start) * 1000, "ms")

        # Pair labels with probabilities and sort descending
        label_probs = sorted(
            zip(self.label_encoder.classes_, probabilities),
            key=lambda pair: pair[1],
            reverse=True,
        )

        return [
            {"fault": str(label), "confidence": round(float(prob), 4)}
            for label, prob in label_probs[:top_n]
        ]