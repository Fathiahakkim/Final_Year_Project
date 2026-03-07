"""ML Model Predictor using HuggingFace DistilBERT for sequence classification."""
import time
import os
import httpx
from typing import List, Tuple
from app.preprocessing.text_cleaner import clean_text


class ModelLoadError(Exception):
    """Exception raised when model files cannot be loaded."""
    pass


class Predictor:
    """ML model predictor that uses HuggingFace Inference API for automotive fault classification."""
    
    def __init__(self):
        """
        Initialize predictor by setting up HuggingFace API endpoint.
        """
        self.api_url = "https://router.huggingface.co/hf-inference/models/Anshi2003/distilbert-model"
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
    
    def predict(self, text: str) -> List[Tuple[str, float]]:
        """
        Predict fault classes for a given complaint text via HuggingFace API.
        
        Applies text cleaning and returns the top 3 class predictions
        sorted by confidence (descending).
        
        Args:
            text: Raw complaint text (will be cleaned and preprocessed)
            
        Returns:
            List of tuples (label, confidence) sorted by confidence (descending).
            Confidence values are between 0.0 and 1.0.
            
        Raises:
            ValueError: If text is empty or invalid
            RuntimeError: If the API request fails
        """
        if not text or not isinstance(text, str):
            raise ValueError("Text cannot be empty and must be a string")
        
        # Apply text cleaning (matches training preprocessing)
        cleaned_text = clean_text(text)
        
        if not cleaned_text or not cleaned_text.strip():
            raise ValueError("Text is empty after cleaning")
        
        payload = {
            "inputs": cleaned_text,
            "options": {"wait_for_model": True}
        }
        
        HF_TOKEN = os.getenv("HF_TOKEN")
        print("HF_TOKEN loaded:", HF_TOKEN is not None)
        headers = {
            "Authorization": f"Bearer {HF_TOKEN}",
            "Content-Type": "application/json"
        }
        
        start = time.time()
        try:
            with httpx.Client() as client:
                response = client.post(
                    self.api_url, 
                    headers=headers, 
                    json=payload, 
                    timeout=60.0
                )
                response.raise_for_status()
                result = response.json()
        except Exception as e:
            raise RuntimeError(f"HuggingFace API request failed: {e}")
        end = time.time()
        print("Inference Time:", (end - start) * 1000, "ms")
        
        predictions = []
        if isinstance(result, list) and len(result) > 0:
            items = result[0] if isinstance(result[0], list) else result
            for item in items:
                label_str = item.get("label", "")
                score = float(item.get("score", 0.0))
                
                # Check if huggingface API returns 'LABEL_X' format
                if label_str.startswith("LABEL_"):
                    try:
                        idx = int(label_str.replace("LABEL_", ""))
                        if idx < len(self.classes_):
                            label_str = self.classes_[idx]
                    except ValueError:
                        pass
                
                predictions.append((label_str, score))
        else:
            raise ValueError(f"Unexpected API response format: {result}")

        # Sort descending
        predictions.sort(key=lambda x: x[1], reverse=True)

        # Return only top 3
        return predictions[:3]
