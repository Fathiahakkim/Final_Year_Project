"""Request schemas for API endpoints."""
from typing import Optional, Dict
from pydantic import BaseModel, Field, field_validator

class DiagnosisRequest(BaseModel):
    """Request schema for diagnosis endpoint."""

    complaint: Optional[str] = Field(
        default=None,
        max_length=500,
        description="Natural language description of the automotive complaint",
        example="Engine is shaking when idling."
    )

    obd_data: Optional[Dict[str, float]] = Field(
        default=None,
        description="Optional dictionary containing extracted OBD sensor features"
    )

    @field_validator('complaint')
    @classmethod
    def validate_complaint(cls, v):
        if v is None:
            return None
        stripped = v.strip()
        return stripped if stripped else None
