from typing import Dict, Any, Optional

def evaluate_confidence(fused_result: Dict[str, Any]) -> Dict[str, Any]:
    """
    Evaluate the confidence of combined predictions and determine if the
    system is confident enough in the results.
    
    Args:
        fused_result: Dictionary containing 'predictions', 
                      'highest_confidence', and 'weights'.
                      
    Returns:
        A dictionary containing confidence evaluation metrics and a 
        feedback message if applicable.
    """
    predictions = fused_result.get("predictions", [])
    
    if not predictions:
        return {
            "low_confidence": True,
            "confidence_gap": 0.0,
            "top_confidence": 0.0,
            "message": "Unable to confidently detect a fault. Please provide more detailed symptoms."
        }
        
    top1 = float(predictions[0][1])
    top2 = float(predictions[1][1]) if len(predictions) > 1 else 0.0
    
    confidence_gap = top1 - top2
    
    low_confidence = (top1 < 0.45) or (confidence_gap < 0.10)
    
    message: Optional[str] = None
    if low_confidence:
        message = "Prediction confidence is low. Please provide more details about the issue."
        
    return {
        "low_confidence": low_confidence,
        "confidence_gap": confidence_gap,
        "top_confidence": top1,
        "message": message
    }
