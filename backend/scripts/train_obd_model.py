import pandas as pd
import numpy as np
import joblib
import os

from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
from sklearn.preprocessing import LabelEncoder

# ----------------------------
# Paths
# ----------------------------




# Get directory of this script
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

TRAIN_PATH = os.path.join(BASE_DIR, "obd_train.csv")
VAL_PATH = os.path.join(BASE_DIR, "obd_val.csv")
TEST_PATH = os.path.join(BASE_DIR, "obd_test.csv")

MODEL_DIR = os.path.join(BASE_DIR, "..", "models", "obd")
os.makedirs(MODEL_DIR, exist_ok=True)

# ----------------------------
# Load Data
# ----------------------------

train_df = pd.read_csv(TRAIN_PATH)
val_df = pd.read_csv(VAL_PATH)
test_df = pd.read_csv(TEST_PATH)

FEATURE_COLUMNS = [col for col in train_df.columns if col != "label"]

X_train = train_df[FEATURE_COLUMNS]
y_train = train_df["label"]

X_val = val_df[FEATURE_COLUMNS]
y_val = val_df["label"]

X_test = test_df[FEATURE_COLUMNS]
y_test = test_df["label"]

# ----------------------------
# Encode Labels
# ----------------------------

label_encoder = LabelEncoder()
y_train_enc = label_encoder.fit_transform(y_train)
y_val_enc = label_encoder.transform(y_val)
y_test_enc = label_encoder.transform(y_test)

# ----------------------------
# Initialize Model
# ----------------------------

model = RandomForestClassifier(
    n_estimators=300,
    max_depth=None,
    min_samples_split=4,
    min_samples_leaf=2,
    random_state=42,
    n_jobs=-1
)

# ----------------------------
# Train
# ----------------------------

print("Training OBD model...")
model.fit(X_train, y_train_enc)

# ----------------------------
# Validation Evaluation
# ----------------------------

val_preds = model.predict(X_val)
val_acc = accuracy_score(y_val_enc, val_preds)

print("\nValidation Accuracy:", val_acc)
print("\nValidation Classification Report:\n")
print(classification_report(y_val_enc, val_preds, target_names=label_encoder.classes_))

# ----------------------------
# Test Evaluation
# ----------------------------

test_preds = model.predict(X_test)
test_acc = accuracy_score(y_test_enc, test_preds)

print("\nTest Accuracy:", test_acc)
print("\nTest Classification Report:\n")
print(classification_report(y_test_enc, test_preds, target_names=label_encoder.classes_))

# ----------------------------
# Confusion Matrix
# ----------------------------

cm = confusion_matrix(y_test_enc, test_preds)
print("\nConfusion Matrix:\n", cm)

# ----------------------------
# Save Model & Encoder
# ----------------------------

joblib.dump(model, os.path.join(MODEL_DIR, "obd_rf_model.joblib"))
joblib.dump(label_encoder, os.path.join(MODEL_DIR, "obd_label_encoder.joblib"))

print("\nModel saved to:", MODEL_DIR)

# ----------------------------
# Save Feature List (for inference safety)
# ----------------------------

joblib.dump(FEATURE_COLUMNS, os.path.join(MODEL_DIR, "obd_features.joblib"))

print("Feature list saved.")