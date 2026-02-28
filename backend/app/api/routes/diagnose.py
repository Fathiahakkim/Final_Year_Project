"""Diagnosis API route."""
import re
from fastapi import APIRouter, HTTPException
from fastapi.responses import JSONResponse
from starlette.requests import Request
from datetime import datetime, timezone
from app.api.schemas.request import DiagnosisRequest
from app.api.schemas.response import DiagnosisResponse, DiagnosedIssue, SuppressionInfo
from app.core.config import settings
from app.utils.suppression import apply_suppression
from app.services.fusion_service import fuse_predictions
from app.services.confidence_service import evaluate_confidence

router = APIRouter(prefix="/api", tags=["diagnosis"])


def is_valid_complaint(text: str | None) -> bool:
    """Validate that the text complaint meets minimum quality standards."""
    if text is None:
        return False
    stripped = text.strip()
    
    # Reject inputs shorter than 8 characters
    if len(stripped) < 8:
        return False
        
    # Reject repeated character spam (ignoring spaces)
    if len(set(stripped.replace(" ", ""))) <= 1:
        return False
        
    # Single-word inputs rejected, words without vowels rejected
    words = stripped.split()
    if len(words) < 2:
        return False
        
    vowels = set('aeiouAEIOU')
    for word in words:
        if not any(char in vowels for char in word):
            return False
            
    return True


@router.post("/diagnose")
async def diagnose_complaint(request: DiagnosisRequest, req: Request):
    """
    Diagnose automotive fault based on natural language complaint and optional OBD data.
    """
    predictor = req.app.state.predictor
    obd_service = getattr(req.app.state, "obd_service", None)
    
    # Strong input validation before hitting the ML model
    if not is_valid_complaint(request.complaint) and not request.obd_data:
        return JSONResponse(
            status_code=400,
            content={
                "error": "Please enter a valid vehicle complaint or upload OBD data."
            }
        )
    
    # 1. Call NLP Predictor
    nlp_preds = []
    if predictor and request.complaint:
        try:
            raw_nlp = predictor.predict(request.complaint)
            nlp_preds, _ = apply_suppression(
                raw_nlp,
                unknown_threshold=settings.unknown_suppression_threshold
            )
        except Exception:
            pass  # Handle gracefully, continue with available modality

    # 2. Call OBD Predictor
    obd_preds = []
    if obd_service and request.obd_data:
        try:
            # obd returns [{"fault": label, "confidence": prob}, ...]
            obd_raw = obd_service.predict_top_faults(request.obd_data, top_n=3)
            obd_preds = [(item["fault"], item["confidence"]) for item in obd_raw]
        except Exception:
            pass  # Handle gracefully

    # 3. Call Fusion Service
    try:
        fused_result = fuse_predictions(nlp_preds, obd_preds)
    except Exception:
        fused_result = {
            "predictions": [],
            "highest_confidence": 0.0,
            "weights": {
                "nlp_weight": 0.0,
                "obd_weight": 0.0
            }
        }

    # 4. Call Confidence Service
    try:
        confidence_result = evaluate_confidence(fused_result)
    except Exception:
        confidence_result = {
            "low_confidence": True,
            "confidence_gap": 0.0,
            "message": "System confidence evaluation unavailable."
        }

    # Return response exactly as specified
    return {
        "predictions": fused_result.get("predictions", []),
        "highest_confidence": float(fused_result.get("highest_confidence", 0.0)),
        "weights": fused_result.get("weights", {"nlp_weight": 0.0, "obd_weight": 0.0}),
        "low_confidence": bool(confidence_result.get("low_confidence", True)),
        "confidence_gap": float(confidence_result.get("confidence_gap", 0.0)),
        "message": confidence_result.get("message")
    }
