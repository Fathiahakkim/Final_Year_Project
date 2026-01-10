"""Confidence-aware suppression logic for filtering UNKNOWN OR OTHER predictions."""
from typing import List, Tuple, Dict


def apply_suppression(
    predictions: List[Tuple[str, float]],
    unknown_threshold: float,
    proximity_threshold: float = 0.15
) -> Tuple[List[Tuple[str, float]], Dict]:
    """
    Apply confidence-aware suppression to filter UNKNOWN OR OTHER predictions.
    
    Rules:
    1. If top prediction is "UNKNOWN OR OTHER", suppress it if:
       - Confidence < unknown_threshold, OR
       - Confidence is within proximity_threshold of the next prediction
    2. When suppressing, promote the next highest non-"UNKNOWN OR OTHER" prediction
    3. Always return top 3 predictions after suppression
    
    Args:
        predictions: List of (label, confidence) tuples sorted by confidence (descending)
        unknown_threshold: Confidence threshold below which UNKNOWN OR OTHER is suppressed
        proximity_threshold: Confidence difference threshold for proximity-based suppression (default: 0.15)
        
    Returns:
        Tuple of:
        - Filtered predictions list (top 3 after suppression)
        - Suppression info dict with "unknown_suppressed" and "other_suppressed" flags
    """
    # Initialize suppression flags
    unknown_suppressed = False
    other_suppressed = False
    
    # If predictions is empty, return it with both flags False
    if not predictions:
        return [], {"unknown_suppressed": False, "other_suppressed": False}
    
    # Work with a copy to avoid modifying the original
    filtered_predictions = predictions.copy()
    
    # Check the top prediction
    label_top, conf_top = filtered_predictions[0]
    
    # If label_top == "UNKNOWN OR OTHER"
    if label_top == "UNKNOWN OR OTHER":
        should_suppress = False
        
        # Check condition a: conf_top < unknown_threshold
        if conf_top < unknown_threshold:
            should_suppress = True
        
        # Check condition b: len(predictions) > 1 AND (conf_top - predictions[1][1]) <= proximity_threshold
        elif len(filtered_predictions) > 1:
            conf_second = filtered_predictions[1][1]
            confidence_diff = conf_top - conf_second
            if confidence_diff <= proximity_threshold:
                should_suppress = True
        
        # When suppressing
        if should_suppress:
            # Find the next highest prediction whose label is NOT "UNKNOWN OR OTHER"
            promoted_prediction = None
            promoted_index = None
            
            for i, (label, conf) in enumerate(filtered_predictions[1:], start=1):
                if label != "UNKNOWN OR OTHER":
                    promoted_prediction = (label, conf)
                    promoted_index = i
                    break
            
            # If we found a non-"UNKNOWN OR OTHER" prediction, promote it
            if promoted_prediction is not None:
                # Remove the suppressed "UNKNOWN OR OTHER" from the top (index 0)
                filtered_predictions.pop(0)
                # Remove the promoted prediction from its current position
                # (index is now one less since we removed from index 0)
                filtered_predictions.pop(promoted_index - 1)
                # Insert the promoted prediction at the top (preserving original confidence)
                filtered_predictions.insert(0, promoted_prediction)
            
            # Set unknown_suppressed = True
            unknown_suppressed = True
    
    # Always return ONLY the top 3 predictions after suppression logic
    top_3 = filtered_predictions[:3]
    
    # Return suppression_info dict exactly as specified
    suppression_info = {
        "unknown_suppressed": unknown_suppressed,
        "other_suppressed": other_suppressed
    }
    
    return top_3, suppression_info
