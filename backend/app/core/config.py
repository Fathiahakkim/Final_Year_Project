"""Configuration settings for the backend application."""
from pydantic_settings import BaseSettings
from typing import List, Union


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    # API Configuration
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    
    # Model Paths
    model_path: str = "artifacts/model.joblib"
    vectorizer_path: str = "artifacts/vectorizer.joblib"
    
    # Suppression Thresholds
    unknown_suppression_threshold: float = 0.5
    other_suppression_threshold: float = 0.5
    
    # CORS Configuration (accepts "*" or comma-separated list)
    cors_origins: Union[str, List[str]] = "*"
    
    # Logging
    log_level: str = "INFO"
    
    def get_cors_origins(self) -> List[str]:
        """Get CORS origins as a list."""
        if self.cors_origins == "*":
            return ["*"]
        if isinstance(self.cors_origins, str):
            return [origin.strip() for origin in self.cors_origins.split(",")]
        return self.cors_origins
    
    class Config:
        env_file = ".env"
        case_sensitive = False


# Global settings instance
settings = Settings()

