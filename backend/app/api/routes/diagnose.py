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

router = APIRouter(prefix="/api", tags=["diagnosis"])


def is_valid_complaint(text: str) -> bool:
    """Validate that the text complaint meets minimum quality standards."""
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


@router.post("/diagnose", response_model=DiagnosisResponse)
async def diagnose_complaint(request: DiagnosisRequest, req: Request):
    """
    Diagnose automotive fault based on natural language complaint.
    
    Args:
        request: DiagnosisRequest containing the complaint text
        req: FastAPI request object to access app.state
        
    Returns:
        DiagnosisResponse with top-3 predictions, confidence scores, and suppression info
        JSONResponse (400) if input validation fails
        
    Raises:
        HTTPException: If model is not loaded
    """
    # Retrieve predictor from request.app.state.predictor
    predictor = req.app.state.predictor
    
    # If predictor is None, raise HTTPException
    if predictor is None:
        raise HTTPException(
            status_code=503,
            detail="Model not loaded"
        )
        
    # Strong input validation before hitting the ML model
    if not is_valid_complaint(request.complaint):
        return JSONResponse(
            status_code=400,
            content={"error": "Please enter a valid vehicle complaint."}
        )
    
    # Call predictor.predict() to get raw predictions
    raw_predictions = predictor.predict(request.complaint)
    
    # Apply suppression
    final_predictions, suppression_info = apply_suppression(
        raw_predictions,
        unknown_threshold=settings.unknown_suppression_threshold
    )
    
    # Build issues list from final_predictions
    issues = []
    for label, confidence in final_predictions:
        # Determine severity based on confidence
        severity = "critical" if confidence >= 0.8 else "warning"
        
        issue = DiagnosedIssue(
            name=label,
            confidence=float(confidence),
            severity=severity
        )
        issues.append(issue)
    
    # Create SuppressionInfo from suppression_info dict
    suppression_applied = SuppressionInfo(
        unknown_suppressed=suppression_info["unknown_suppressed"],
        other_suppressed=suppression_info["other_suppressed"]
    )
    
    # Hybrid Confidence Handling
    highest_confidence = final_predictions[0][1] if len(final_predictions) > 0 else 0.0
    second_confidence = final_predictions[1][1] if len(final_predictions) > 1 else 0.0
    
    # Low confidence if the top score is weak, OR if the model is torn between the top two
    low_confidence = (highest_confidence < 0.40) or ((highest_confidence - second_confidence) < 0.10)
    
    message = (
        "The prediction confidence is low. Please provide more details about the issue."
        if low_confidence else None
    )
    
    # Return DiagnosisResponse with current UTC ISO timestamp
    return DiagnosisResponse(
        issues=issues,
        timestamp=datetime.now(timezone.utc),
        suppression_applied=suppression_applied,
        low_confidence=low_confidence,
        message=message
    )

