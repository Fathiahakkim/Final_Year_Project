"""ML Model Predictor using HuggingFace DistilBERT for sequence classification."""
import numpy as np
import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification
from typing import List, Tuple
from app.preprocessing.text_cleaner import clean_text


class ModelLoadError(Exception):
    """Exception raised when model files cannot be loaded."""
    pass


class Predictor:
    """ML model predictor that loads a fine-tuned DistilBERT model for automotive fault classification."""
    
    def __init__(self):
        """
        Initialize predictor by loading DistilBERT model from HuggingFace.
        
        Raises:
            ModelLoadError: If model cannot be loaded
        """
        self.model = None
        self.tokenizer = None
        self.classes_ = None
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        
        self._load_models()
    
    def _load_models(self):
        """Load DistilBERT model/tokenizer and extract class labels from model config."""
        hf_model_name = "Anshi2003/distilbert-model"
        try:
            self.tokenizer = AutoTokenizer.from_pretrained(hf_model_name)
            self.model = AutoModelForSequenceClassification.from_pretrained(
                hf_model_name
            )
            self.model.to(self.device)
            self.model.eval()

            # Class labels in EXACT training order
            self.classes_ = [
                "AIR",
                "AIR BAGS",
                "BACK OVER PREVENTION",
                "DIESEL",
                "ELECTRICAL SYSTEM",
                "ELECTRONIC STABILITY CONTROL (ESC)",
                "ENGINE",
                "ENGINE AND ENGINE COOLING",
                "EQUIPMENT",
                "EXTERIOR LIGHTING",
                "FORWARD COLLISION AVOIDANCE",
                "FUEL SYSTEM",
                "FUEL/PROPULSION SYSTEM",
                "GASOLINE",
                "HYBRID PROPULSION SYSTEM",
                "HYDRAULIC",
                "LANE DEPARTURE",
                "LATCHES/LOCKS/LINKAGES",
                "PARKING BRAKE",
                "POWER TRAIN",
                "RARE_OTHER",
                "SEAT BELTS",
                "SEATS",
                "SERVICE BRAKES",
                "STEERING",
                "STRUCTURE",
                "SUSPENSION",
                "TIRES",
                "TRACTION CONTROL SYSTEM",
                "TRAILER HITCHES",
                "UNKNOWN OR OTHER",
                "VEHICLE SPEED CONTROL",
                "VISIBILITY",
                "VISIBILITY/WIPER",
                "WHEELS",
            ]
        except Exception as e:
            raise ModelLoadError(
                f"Error loading DistilBERT model '{hf_model_name}': {str(e)}. "
                f"Please ensure you have internet access or the model is "
                f"cached locally."
            ) from e
    
    def predict(self, text: str) -> List[Tuple[str, float]]:
        """
        Predict fault classes for a given complaint text.
        
        Applies text cleaning and returns the top 3 class predictions
        sorted by confidence (descending).
        
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
        
        # Tokenize the cleaned text for DistilBERT
        inputs = self.tokenizer(
            cleaned_text,
            return_tensors="pt",
            truncation=True,
            padding=True,
            max_length=512,
        ).to(self.device)

        # Run inference (no gradient computation needed)
        with torch.no_grad():
            logits = self.model(**inputs).logits

        probabilities = torch.softmax(logits, dim=-1)[0].cpu().numpy()

        predictions = [(label, float(prob))
                       for label, prob in zip(self.classes_, probabilities)]

        predictions.sort(key=lambda x: x[1], reverse=True)

        # Return only top 3
        return predictions[:3]
