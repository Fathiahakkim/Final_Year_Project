from typing import List, Tuple, Dict, Any

def fuse_predictions(
    nlp_preds: List[Tuple[str, float]],
    obd_preds: List[Tuple[str, float]]
) -> Dict[str, Any]:
    """
    Perform Confidence-Adaptive Weighted Late Fusion on predictions
    from two modalities (NLP and OBD).

    Args:
        nlp_preds: List of tuples (label, confidence) from NLP model.
        obd_preds: List of tuples (label, confidence) from OBD model.

    Returns:
        Dict containing top-3 fused predictions, highest fused confidence,
        and dynamically calculated weights for each modality.
    """
    # CASE 3: Both empty
    if not nlp_preds and not obd_preds:
        return {
            "predictions": [],
            "highest_confidence": 0.0,
            "weights": {"nlp_weight": 1.0, "obd_weight": 0.0}
        }

    # CASE 1: Only NLP predictions exist
    if nlp_preds and not obd_preds:
        top3_list = nlp_preds[:3]
        return {
            "predictions": top3_list,
            "highest_confidence": float(top3_list[0][1]) if top3_list else 0.0,
            "weights": {"nlp_weight": 1.0, "obd_weight": 0.0}
        }

    # CASE 2: Only OBD predictions exist
    if obd_preds and not nlp_preds:
        top3_list = obd_preds[:3]
        return {
            "predictions": top3_list,
            "highest_confidence": float(top3_list[0][1]) if top3_list else 0.0,
            "weights": {"nlp_weight": 0.0, "obd_weight": 1.0}
        }

    # CASE 4: Both exist -> existing weighted logic
    # 1. Extract top1 confidence from each modality
    nlp_conf = float(nlp_preds[0][1])
    obd_conf = float(obd_preds[0][1])

    # 2. Compute dynamic weights
    total = nlp_conf + obd_conf + 1e-8  # 1e-8 prevents division by zero
    w_nlp = nlp_conf / total
    w_obd = obd_conf / total

    # 3. Merge unique labels from both lists
    nlp_dict = {label: float(score) for label, score in nlp_preds}
    obd_dict = {label: float(score) for label, score in obd_preds}
    all_labels = set(nlp_dict.keys()).union(set(obd_dict.keys()))

    # 4. Compute fused scores for each label
    fused_results = []
    for label in all_labels:
        nlp_score = nlp_dict.get(label, 0.0)
        obd_score = obd_dict.get(label, 0.0)
        
        final_score = (w_nlp * nlp_score) + (w_obd * obd_score)
        fused_results.append((label, final_score))

    # 5. Sort descending and extract top 3
    fused_results.sort(key=lambda item: (item[1], item[0]), reverse=True)
    top3_list = fused_results[:3]

    highest_confidence = float(top3_list[0][1]) if top3_list else 0.0

    # 6. Return structured dictionary
    return {
        "predictions": top3_list,
        "highest_confidence": highest_confidence,
        "weights": {
            "nlp_weight": w_nlp,
            "obd_weight": w_obd
        }
    }
