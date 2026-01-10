"""FastAPI application entry point."""
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.routes import diagnose, transcribe
from app.models.predictor import Predictor, ModelLoadError
from app.services.whisper_service import WhisperService
import logging

# Configure logging
logging.basicConfig(level=getattr(logging, settings.log_level.upper()))
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Lifespan context manager for startup and shutdown events.
    Loads ML model and Whisper service on startup and stores them in app.state.
    """
    # Startup: Load predictor
    logger.info("Loading ML models...")
    try:
        predictor = Predictor(
            model_path=settings.model_path,
            vectorizer_path=settings.vectorizer_path
        )
        app.state.predictor = predictor
        logger.info(f"Successfully loaded model from {settings.model_path}")
        logger.info(f"Successfully loaded vectorizer from {settings.vectorizer_path}")
        logger.info(f"Model supports {len(predictor.classes_)} classes: {list(predictor.classes_)}")
    except ModelLoadError as e:
        logger.error(f"Failed to load models: {e}")
        logger.error("API will start but /api/diagnose will not work until models are available.")
        app.state.predictor = None
    except Exception as e:
        logger.error(f"Unexpected error loading models: {e}")
        app.state.predictor = None
    
    # Startup: Load Whisper service
    # logger.info("Loading Whisper service...")
    # try:
    #     whisper_service = WhisperService(model_name="large", fp16=False)
    #     app.state.whisper_service = whisper_service
    #     logger.info("Successfully loaded Whisper service with 'large' model")
    # except Exception as e:
    #     logger.error(f"Failed to load Whisper service: {e}")
    #     logger.error("API will start but /api/v1/transcribe will not work until Whisper is available.")
    #     app.state.whisper_service = None
    app.state.whisper_service = None
    
    yield
    
    # Shutdown: Cleanup (if needed)
    logger.info("Shutting down...")


# Create FastAPI application with lifespan
app = FastAPI(
    title="AI-Based Automotive Fault Detection API",
    description="Backend API for diagnosing automotive faults from natural language complaints",
    version="1.0.0",
    lifespan=lifespan
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.get_cors_origins(),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register API routes
app.include_router(diagnose.router)
app.include_router(transcribe.router)


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "message": "AI-Based Automotive Fault Detection API",
        "version": "1.0.0",
        "docs": "/docs",
        "model_loaded": app.state.predictor is not None,
        "whisper_loaded": app.state.whisper_service is not None
    }


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {
        "status": "healthy",
        "model_loaded": app.state.predictor is not None,
        "whisper_loaded": app.state.whisper_service is not None
    }

