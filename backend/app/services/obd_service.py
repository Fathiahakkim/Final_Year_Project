import joblib
import numpy as np
from pathlib import Path

class OBDService:

    def __init__(self):
        base_path = Path(__file__).resolve().parent.parent.parent / "models" / "obd"

        self.model = joblib.load(base_path / "obd_rf_model.joblib")
        self.label_encoder = joblib.load(base_path / "obd_label_encoder.joblib")
        self.feature_list = joblib.load(base_path / "obd_features.joblib")

    def predict_proba(self, feature_dict):

        X = np.array([[feature_dict[f] for f in self.feature_list]])
        probs = self.model.predict_proba(X)[0]

        class_probs = {
            label: float(prob)
            for label, prob in zip(self.label_encoder.classes_, probs)
        }

        return class_probs