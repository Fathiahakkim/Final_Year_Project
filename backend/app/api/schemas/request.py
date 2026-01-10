"""Request schemas for API endpoints."""
from pydantic import BaseModel, Field, field_validator


class DiagnosisRequest(BaseModel):
    """Request schema for diagnosis endpoint."""
    
    complaint: str = Field(
        ...,
        min_length=1,
        max_length=500,
        description="Natural language description of the automotive complaint",
        example="Engine is shaking when idling."
    )
    
    @field_validator('complaint')
    @classmethod
    def validate_complaint(cls, v: str) -> str:
        """Validate complaint is not empty after stripping."""
        stripped = v.strip()
        if not stripped:
            raise ValueError("Complaint cannot be empty")
        return stripped

