"""OBD fault-detection API route.

Provides ``POST /api/v1/obd/predict`` — accepts a CSV file upload,
extracts features, runs the OBD model, and returns the top-3 faults.

This module only orchestrates the HTTP request/response; all business
logic lives in ``obd_service`` and ``obd_feature_extractor``.
"""

from __future__ import annotations

import logging

from fastapi import APIRouter, File, HTTPException, UploadFile
from starlette.requests import Request

from app.utils.obd_feature_extractor import extract_features_from_csv, MAX_CSV_SIZE_BYTES

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/obd", tags=["obd"])


@router.post("/predict")
async def predict_obd_faults(
    req: Request,
    file: UploadFile = File(..., description="CSV file with OBD sensor data"),
):
    """Predict automotive faults from an uploaded OBD sensor CSV.

    **Accepts** ``multipart/form-data`` with a single CSV file.

    **Returns** a JSON object with ``source`` and ``top_faults``.
    """
    # ── 1. Validate that the OBD service is available ──────────────────
    obd_service = getattr(req.app.state, "obd_service", None)
    if obd_service is None:
        raise HTTPException(
            status_code=503,
            detail="OBD model is not loaded. Service unavailable.",
        )

    # ── 2. Validate uploaded file type ─────────────────────────────────
    if file.content_type not in (
        "text/csv",
        "application/vnd.ms-excel",
        "application/octet-stream",
    ):
        raise HTTPException(
            status_code=400,
            detail=(
                f"Invalid file type '{file.content_type}'. "
                "Please upload a CSV file."
            ),
        )

    # ── 3. Read file bytes with size guard ─────────────────────────────
    try:
        csv_bytes = await file.read()
    except Exception as exc:
        logger.error("Error reading uploaded file: %s", exc)
        raise HTTPException(
            status_code=400,
            detail="Could not read the uploaded file.",
        )

    if not csv_bytes:
        raise HTTPException(status_code=400, detail="Uploaded file is empty.")

    if len(csv_bytes) > MAX_CSV_SIZE_BYTES:
        raise HTTPException(
            status_code=413,
            detail=(
                f"File too large ({len(csv_bytes) / (1024*1024):.1f} MB). "
                f"Maximum allowed is {MAX_CSV_SIZE_BYTES // (1024*1024)} MB."
            ),
        )

    # ── 4. Extract features (CSV → feature dict) ──────────────────────
    try:
        feature_dict = extract_features_from_csv(csv_bytes)
    except ValueError as exc:
        raise HTTPException(status_code=422, detail=str(exc))

    # ── 5. Run prediction ──────────────────────────────────────────────
    try:
        top_faults = obd_service.predict_top_faults(feature_dict, top_n=3)
    except KeyError as exc:
        raise HTTPException(
            status_code=422,
            detail=f"Feature mismatch — missing key in extracted features: {exc}",
        )
    except Exception as exc:
        logger.error("OBD prediction failed: %s", exc)
        raise HTTPException(
            status_code=500,
            detail="Internal error during OBD prediction.",
        )

    # ── 6. Return structured response ─────────────────────────────────
    return {
        "source": "OBD",
        "top_faults": top_faults,
    }
