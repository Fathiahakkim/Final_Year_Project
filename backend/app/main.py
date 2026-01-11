"""FastAPI application entry point."""
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.routes import diagnose
from app.models.predictor import Predictor, ModelLoadError

import logging

# Configure logging
logging.basicConfig(level=getattr(logging, settings.log_level.upper()))
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Lifespan context manager for startup and shutdown events.
    Loads ML model on startup and stores it in app.state.
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


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "message": "AI-Based Automotive Fault Detection API",
        "version": "1.0.0",
        "docs": "/docs",
        "model_loaded": app.state.predictor is not None,
    }


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {
        "status": "healthy",
        "model_loaded": app.state.predictor is not None,
    }

