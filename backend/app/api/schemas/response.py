"""Response schemas for API endpoints."""
from pydantic import BaseModel, Field
from datetime import datetime
from typing import List


class DiagnosedIssue(BaseModel):
    """Schema for a single diagnosed issue."""
    
    name: str = Field(
        ...,
        description="Name of the diagnosed fault",
        example="Engine Misfire"
    )
    confidence: float = Field(
        ...,
        ge=0.0,
        le=1.0,
        description="Confidence score between 0.0 and 1.0",
        example=0.92
    )
    severity: str = Field(
        ...,
        description="Severity level: 'critical' or 'warning'",
        example="critical"
    )


class SuppressionInfo(BaseModel):
    """Information about suppression that was applied."""
    
    unknown_suppressed: bool = Field(
        ...,
        description="Whether UNKNOWN class was suppressed",
        example=False
    )
    other_suppressed: bool = Field(
        ...,
        description="Whether OTHER class was suppressed",
        example=True
    )


class DiagnosisResponse(BaseModel):
    """Response schema for diagnosis endpoint."""
    
    issues: List[DiagnosedIssue] = Field(
        ...,
        description="List of diagnosed issues (top-3 predictions)",
        example=[
            {
                "name": "Engine Misfire",
                "confidence": 0.92,
                "severity": "critical"
            },
            {
                "name": "Worn Engine Mounts",
                "confidence": 0.78,
                "severity": "warning"
            }
        ]
    )
    timestamp: datetime = Field(
        ...,
        description="ISO8601 timestamp of when diagnosis was performed",
        example="2024-01-15T10:30:00.123456Z"
    )
    suppression_applied: SuppressionInfo = Field(
        ...,
        description="Information about suppression that was applied",
        example={
            "unknown_suppressed": False,
            "other_suppressed": True
        }
    )


class TranscriptionResponse(BaseModel):
    """Response schema for transcription endpoint."""
    
    text: str = Field(
        ...,
        description="Transcribed text from audio file",
        example="My car engine is making a strange noise when I accelerate"
    )
