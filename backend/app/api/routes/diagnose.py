"""Diagnosis API route."""
from fastapi import APIRouter, HTTPException
from starlette.requests import Request
from datetime import datetime, timezone
from app.api.schemas.request import DiagnosisRequest
from app.api.schemas.response import DiagnosisResponse, DiagnosedIssue, SuppressionInfo
from app.core.config import settings
from app.utils.suppression import apply_suppression

router = APIRouter(prefix="/api", tags=["diagnosis"])


@router.post("/diagnose", response_model=DiagnosisResponse)
async def diagnose_complaint(request: DiagnosisRequest, req: Request):
    """
    Diagnose automotive fault based on natural language complaint.
    
    Args:
        request: DiagnosisRequest containing the complaint text
        req: FastAPI request object to access app.state
        
    Returns:
        DiagnosisResponse with top-3 predictions, confidence scores, and suppression info
        
    Raises:
        HTTPException: If model is not loaded or request validation fails
    """
    # Retrieve predictor from request.app.state.predictor
    predictor = req.app.state.predictor
    
    # If predictor is None, raise HTTPException
    if predictor is None:
        raise HTTPException(
            status_code=503,
            detail="Model not loaded"
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
    
    # Return DiagnosisResponse with current UTC ISO timestamp
    return DiagnosisResponse(
        issues=issues,
        timestamp=datetime.now(timezone.utc),
        suppression_applied=suppression_applied
    )

