"""ML Model Predictor for loading and using trained TF-IDF + Logistic Regression model."""
import joblib
import numpy as np
from pathlib import Path
from typing import List, Tuple
from app.preprocessing.text_cleaner import clean_text
from app.core.config import settings


class ModelLoadError(Exception):
    """Exception raised when model files cannot be loaded."""
    pass


class Predictor:
    """ML model predictor that loads and uses trained TF-IDF vectorizer and Logistic Regression model."""
    
    def __init__(self, model_path: str = None, vectorizer_path: str = None):
        """
        Initialize predictor by loading model and vectorizer from disk.
        
        Args:
            model_path: Path to model.joblib file (defaults to settings.model_path)
            vectorizer_path: Path to vectorizer.joblib file (defaults to settings.vectorizer_path)
            
        Raises:
            ModelLoadError: If model files are missing or cannot be loaded
        """
        self.model_path = model_path or settings.model_path
        self.vectorizer_path = vectorizer_path or settings.vectorizer_path
        self.model = None
        self.vectorizer = None
        self.classes_ = None
        
        self._load_models()
    
    def _load_models(self):
        """Load model and vectorizer from disk."""
        # Resolve paths relative to backend directory
        backend_dir = Path(__file__).parent.parent.parent
        model_full_path = backend_dir / self.model_path
        vectorizer_full_path = backend_dir / self.vectorizer_path
        
        # Check if files exist
        if not model_full_path.exists():
            raise ModelLoadError(
                f"Model file not found: {model_full_path}. "
                f"Please ensure model.joblib is placed in the artifacts directory."
            )
        
        if not vectorizer_full_path.exists():
            raise ModelLoadError(
                f"Vectorizer file not found: {vectorizer_full_path}. "
                f"Please ensure vectorizer.joblib is placed in the artifacts directory."
            )
        
        # Load model and vectorizer
        try:
            self.model = joblib.load(model_full_path)
            self.vectorizer = joblib.load(vectorizer_full_path)
            
            # Get class labels from the model
            if hasattr(self.model, 'classes_'):
                self.classes_ = self.model.classes_
            else:
                raise ModelLoadError("Loaded model does not have 'classes_' attribute.")
            
        except Exception as e:
            raise ModelLoadError(
                f"Error loading model files: {str(e)}. "
                f"Please ensure the files are valid joblib files."
            ) from e
    
    def predict(self, text: str) -> List[Tuple[str, float]]:
        """
        Predict fault classes for a given complaint text.
        
        Applies text cleaning, vectorization, and returns ALL class predictions
        sorted by confidence (descending). Does NOT apply suppression or truncation.
        
        Args:
            text: Raw complaint text (will be cleaned and preprocessed)
            
        Returns:
            List of tuples (label, confidence) sorted by confidence (descending).
            Confidence values are between 0.0 and 1.0.
            
        Raises:
            ValueError: If text is empty or invalid
        """
        if not text or not isinstance(text, str):
            raise ValueError("Text cannot be empty and must be a string")
        
        # Apply text cleaning (matches training preprocessing)
        cleaned_text = clean_text(text)
        
        if not cleaned_text or not cleaned_text.strip():
            raise ValueError("Text is empty after cleaning")
        
        # Vectorize the cleaned text
        text_vectorized = self.vectorizer.transform([cleaned_text])
        
        # Get prediction probabilities for all classes
        probabilities = self.model.predict_proba(text_vectorized)[0]
        
        # Pair model classes with probabilities
        predictions = list(zip(self.classes_, probabilities))
        
        # Sort by confidence (descending)
        predictions.sort(key=lambda x: x[1], reverse=True)
        
        return predictions

