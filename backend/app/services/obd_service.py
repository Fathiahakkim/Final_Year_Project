"""OBD fault-detection service.

Responsible for:
  - Calling the HuggingFace Inference API for the trained RandomForest model.
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

import httpx

logger = logging.getLogger(__name__)


class OBDModelLoadError(Exception):
    """Raised when the OBD model API fails."""


class OBDService:
    """Singleton-style service that wraps the OBD API."""

    def __init__(self, model_dir: str | Path | None = None) -> None:
        """Initialize the API endpoint URL.

        Parameters
        ----------
        model_dir : str | Path | None
            Ignored. Kept for backward compatibility with the constructor signature.
        """
        self.api_url = "https://router.huggingface.co/hf-inference/models/Anshi2003/obd-rf-model"
        logger.info("OBD service configured to use HuggingFace inference API.")

    # ── Public API ─────────────────────────────────────────────────────
    def predict_top_faults(
        self,
        feature_dict: Dict[str, float],
        top_n: int = 3,
    ) -> List[Dict[str, Any]]:
        """Return the *top_n* most likely faults with confidence scores via HuggingFace API.

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
        # We assume the API can handle the structured feature dictionary directly 
        # as a singular JSON row. HuggingFace scikit-learn endpoints typically support this.
        # Ensure it is a 2D array format or structurally uniform representation.
        feature_vector = list(feature_dict.values())
        payload = {"inputs": [feature_vector]}

        start = time.time()
        
        HF_TOKEN = os.getenv("HF_TOKEN")
        headers = {
            "Authorization": f"Bearer {HF_TOKEN}"
        }
        
        try:
            with httpx.Client() as client:
                response = client.post(
                    self.api_url, 
                    headers=headers, 
                    json=payload, 
                    timeout=60.0
                )
                response.raise_for_status()
                result = response.json()
        except Exception as exc:
            raise RuntimeError(f"HuggingFace OBD API request failed: {exc}") from exc
        end = time.time()
        
        print("OBD Inference Time:", (end - start) * 1000, "ms")

        # Handle API result formatting
        predictions = []
        if isinstance(result, list) and len(result) > 0:
            items = result[0] if isinstance(result[0], list) else result
            for item in items:
                label_str = str(item.get("label", ""))
                score = round(float(item.get("score", 0.0)), 4)
                predictions.append({"fault": label_str, "confidence": score})
        else:
            raise ValueError(f"Unexpected OBD API response format: {result}")

        # Sort descending by confidence
        predictions.sort(key=lambda x: x["confidence"], reverse=True)

        return predictions[:top_n]