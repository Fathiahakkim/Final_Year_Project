"""OBD CSV feature extraction utility.

Responsible for:
  - Parsing an uploaded CSV file into a pandas DataFrame.
  - Validating that all required columns exist (exact match with model schema).
  - Handling NaN / missing values gracefully.
  - Returning the feature dictionary expected by the OBD model.

This module does NOT know about the model or the HTTP layer — it only
deals with data transformation.
"""

from __future__ import annotations

import io
from typing import Dict, List

import numpy as np
import pandas as pd


# ── Maximum allowed CSV file size (10 MB) ─────────────────────────────────
MAX_CSV_SIZE_BYTES: int = 10 * 1024 * 1024  # 10 MB

# ── Aggregated feature columns the model expects ──────────────────────────
# These match the features saved in obd_features.joblib and the training
# dataset schema (rpm_mean, rpm_std, coolant_mean, coolant_max, …).
REQUIRED_FEATURE_COLUMNS: List[str] = [
    "rpm_mean",
    "rpm_std",
    "coolant_mean",
    "coolant_max",
    "speed_mean",
    "throttle_mean",
    "engine_load_mean",
    "fuel_trim_mean",
    "o2_var",
    "battery_voltage_mean",
]


def _validate_file_size(csv_bytes: bytes) -> None:
    """Raise ``ValueError`` if the file exceeds the size limit."""
    if len(csv_bytes) > MAX_CSV_SIZE_BYTES:
        size_mb = len(csv_bytes) / (1024 * 1024)
        raise ValueError(
            f"CSV file is too large ({size_mb:.1f} MB). "
            f"Maximum allowed size is {MAX_CSV_SIZE_BYTES // (1024 * 1024)} MB."
        )


def _validate_columns(df: pd.DataFrame) -> None:
    """Raise ``ValueError`` if required feature columns are missing."""
    missing = [col for col in REQUIRED_FEATURE_COLUMNS if col not in df.columns]
    if missing:
        raise ValueError(
            f"CSV is missing required columns: {missing}. "
            f"Expected columns: {REQUIRED_FEATURE_COLUMNS}"
        )


def _validate_no_nans(feature_dict: Dict[str, float]) -> None:
    """Raise ``ValueError`` if any feature value is NaN or infinite."""
    bad_keys = [
        k for k, v in feature_dict.items()
        if v is None or np.isnan(v) or np.isinf(v)
    ]
    if bad_keys:
        raise ValueError(
            f"CSV contains NaN or infinite values in columns: {bad_keys}. "
            "Please ensure all sensor readings are valid numeric values."
        )


def extract_features_from_csv(csv_bytes: bytes) -> Dict[str, float]:
    """Convert an OBD CSV file into the feature dict expected by the model.

    The CSV should contain pre-aggregated feature columns that match the
    model's training schema (``rpm_mean``, ``rpm_std``, ``coolant_mean``,
    ``coolant_max``, ``speed_mean``, ``throttle_mean``,
    ``engine_load_mean``, ``fuel_trim_mean``, ``o2_var``,
    ``battery_voltage_mean``).

    If the CSV has multiple rows, the **mean** of each feature column is
    used (treating it as multiple OBD snapshots for the same session).

    Parameters
    ----------
    csv_bytes : bytes
        Raw bytes of the uploaded CSV file.

    Returns
    -------
    dict[str, float]
        Feature dictionary keyed by feature name.

    Raises
    ------
    ValueError
        If the file is too large, cannot be parsed, required columns are
        missing, or feature values contain NaN / infinities.
    """
    # ── Size guard ─────────────────────────────────────────────────────
    _validate_file_size(csv_bytes)

    # ── Parse CSV ──────────────────────────────────────────────────────
    try:
        df = pd.read_csv(io.BytesIO(csv_bytes))
    except Exception as exc:
        raise ValueError(f"Failed to parse CSV file: {exc}") from exc

    if df.empty:
        raise ValueError("CSV file is empty — no data rows found.")

    # ── Column validation ──────────────────────────────────────────────
    _validate_columns(df)

    # ── Build feature dict ─────────────────────────────────────────────
    # Use mean across rows so a multi-row CSV is handled sensibly.
    features: Dict[str, float] = {
        col: float(df[col].mean()) for col in REQUIRED_FEATURE_COLUMNS
    }

    # ── NaN / Inf guard ────────────────────────────────────────────────
    _validate_no_nans(features)

    return features
