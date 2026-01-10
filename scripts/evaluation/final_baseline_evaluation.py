"""
Final Baseline Model Evaluation Script

This script evaluates the trained baseline model on the test set.
It uses the SAME preprocessing and data splitting as training.

Key Requirements:
- Load cleaned dataset: data/processed/step4_cleaned_text.csv
- Load trained artifacts: models/baseline/model.joblib, models/baseline/vectorizer.joblib
- Use exact same preprocessing (clean_text from backend)
- Split data 80/20 stratified with random_state=42
- Evaluate on TEST SET ONLY
- Compute accuracy, macro/weighted F1, classification report
- Save results to evaluation/results/
- DO NOT apply suppression, DO NOT retrain, DO NOT rebalance
"""
import sys
import os
from pathlib import Path
import pandas as pd
import joblib
import json
from sklearn.model_selection import train_test_split
from sklearn.metrics import (
    accuracy_score,
    f1_score,
    classification_report,
    confusion_matrix
)
import numpy as np

# Add backend to path to import clean_text
backend_path = Path(__file__).parent.parent.parent / "backend"
sys.path.insert(0, str(backend_path))

from app.preprocessing.text_cleaner import clean_text


def load_dataset(csv_path: str) -> pd.DataFrame:
    """Load the processed dataset."""
    print(f"Loading dataset from: {csv_path}")
    df = pd.read_csv(csv_path)
    print(f"  Loaded {len(df)} rows")
    print(f"  Columns: {list(df.columns)}")
    return df


def load_model_artifacts(model_path: str, vectorizer_path: str):
    """Load trained model and vectorizer."""
    print(f"\nLoading model artifacts...")
    print(f"  Model: {model_path}")
    print(f"  Vectorizer: {vectorizer_path}")
    
    model = joblib.load(model_path)
    vectorizer = joblib.load(vectorizer_path)
    
    print(f"  Model classes: {len(model.classes_)}")
    print(f"  Vectorizer vocabulary size: {len(vectorizer.vocabulary_) if hasattr(vectorizer, 'vocabulary_') else 'N/A'}")
    
    return model, vectorizer


def split_data(df: pd.DataFrame, target_col: str, random_state: int = 42):
    """
    Split data exactly as training did: 80/20 stratified.
    
    Args:
        df: DataFrame with data
        target_col: Name of the target/label column
        random_state: Random seed for reproducibility
        
    Returns:
        X_train, X_test, y_train, y_test
    """
    print(f"\nSplitting data (80/20 stratified, random_state={random_state})...")
    
    # Extract features and target
    # Assuming 'summary' is the text column and target_col is the label column
    X = df['summary'].copy()
    y = df[target_col].copy()
    
    # Remove rows with NaN values in either X or y (matching training behavior)
    valid_mask = X.notna() & y.notna()
    X = X[valid_mask]
    y = y[valid_mask]
    
    print(f"  After removing NaN: {len(X)} samples")
    
    # Stratified split
    X_train, X_test, y_train, y_test = train_test_split(
        X, y,
        test_size=0.2,
        random_state=random_state,
        stratify=y
    )
    
    print(f"  Train set: {len(X_train)} samples")
    print(f"  Test set: {len(X_test)} samples")
    print(f"  Train label distribution:\n{y_train.value_counts().head(10)}")
    print(f"  Test label distribution:\n{y_test.value_counts().head(10)}")
    
    return X_train, X_test, y_train, y_test


def preprocess_text(text_series: pd.Series) -> pd.Series:
    """
    Apply clean_text preprocessing to text series.
    Uses the SAME preprocessing as training.
    """
    print("\nPreprocessing text (applying clean_text)...")
    cleaned = text_series.apply(clean_text)
    print(f"  Processed {len(cleaned)} texts")
    return cleaned


def evaluate_model(model, vectorizer, X_test, y_test):
    """
    Perform inference on test set and compute metrics.
    
    Args:
        model: Trained model
        vectorizer: Trained vectorizer
        X_test: Test features (text)
        y_test: Test labels
        
    Returns:
        y_pred: Predictions
        y_proba: Prediction probabilities (if available)
        metrics: Dictionary of computed metrics
    """
    print("\nPerforming inference on test set...")
    
    # Preprocess test texts
    X_test_cleaned = X_test.apply(clean_text)
    
    # Vectorize
    print("  Vectorizing test texts...")
    X_test_vectorized = vectorizer.transform(X_test_cleaned)
    
    # Predict
    print("  Generating predictions...")
    y_pred = model.predict(X_test_vectorized)
    
    # Get probabilities
    print("  Computing probabilities...")
    y_proba = model.predict_proba(X_test_vectorized)
    
    print(f"  Completed inference on {len(y_test)} test samples")
    
    # Compute metrics
    print("\nComputing metrics...")
    accuracy = accuracy_score(y_test, y_pred)
    macro_f1 = f1_score(y_test, y_pred, average='macro', zero_division=0)
    weighted_f1 = f1_score(y_test, y_pred, average='weighted', zero_division=0)
    
    # Classification report
    class_report = classification_report(
        y_test, y_pred,
        output_dict=True,
        zero_division=0
    )
    
    metrics = {
        'accuracy': float(accuracy),
        'macro_f1': float(macro_f1),
        'weighted_f1': float(weighted_f1),
        'classification_report': class_report
    }
    
    return y_pred, y_proba, metrics


def save_results(metrics: dict, y_test, y_pred, output_dir: Path):
    """Save evaluation results to files."""
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Save classification report as text
    report_path = output_dir / "final_classification_report.txt"
    print(f"\nSaving classification report to: {report_path}")
    
    with open(report_path, 'w') as f:
        f.write("=" * 70 + "\n")
        f.write("FINAL BASELINE MODEL EVALUATION REPORT\n")
        f.write("=" * 70 + "\n\n")
        
        f.write(f"Accuracy: {metrics['accuracy']:.4f}\n")
        f.write(f"Macro F1-score: {metrics['macro_f1']:.4f}\n")
        f.write(f"Weighted F1-score: {metrics['weighted_f1']:.4f}\n")
        f.write(f"Total Test Samples: {len(y_test)}\n\n")
        
        f.write("-" * 70 + "\n")
        f.write("CLASSIFICATION REPORT\n")
        f.write("-" * 70 + "\n\n")
        
        # Generate string classification report
        report_str = classification_report(
            y_test, y_pred,
            zero_division=0
        )
        f.write(report_str)
        
        f.write("\n" + "=" * 70 + "\n")
        f.write("Per-class details:\n")
        f.write("=" * 70 + "\n\n")
        
        report_dict = metrics['classification_report']
        
        # Header
        f.write(f"{'Class':<30} {'Precision':<12} {'Recall':<12} {'F1-Score':<12} {'Support':<12}\n")
        f.write("-" * 70 + "\n")
        
        # Per-class metrics (exclude summary rows)
        for class_name, class_metrics in report_dict.items():
            if (isinstance(class_metrics, dict) and 
                'precision' in class_metrics and 
                class_name not in ['macro avg', 'weighted avg', 'accuracy']):
                f.write(f"{class_name:<30} "
                       f"{class_metrics['precision']:<12.4f} "
                       f"{class_metrics['recall']:<12.4f} "
                       f"{class_metrics['f1-score']:<12.4f} "
                       f"{class_metrics['support']:<12.0f}\n")
        
        # Summary metrics
        f.write("\n" + "-" * 70 + "\n")
        if 'macro avg' in report_dict:
            avg = report_dict['macro avg']
            f.write(f"{'macro avg':<30} "
                   f"{avg['precision']:<12.4f} "
                   f"{avg['recall']:<12.4f} "
                   f"{avg['f1-score']:<12.4f} "
                   f"{avg['support']:<12.0f}\n")
        
        if 'weighted avg' in report_dict:
            avg = report_dict['weighted avg']
            f.write(f"{'weighted avg':<30} "
                   f"{avg['precision']:<12.4f} "
                   f"{avg['recall']:<12.4f} "
                   f"{avg['f1-score']:<12.4f} "
                   f"{avg['support']:<12.0f}\n")
    
    # Save metrics as JSON
    json_path = output_dir / "final_metrics.json"
    print(f"Saving metrics JSON to: {json_path}")
    
    # Convert numpy types to native Python types for JSON serialization
    def convert_to_serializable(obj):
        if isinstance(obj, (np.integer, np.floating)):
            return float(obj)
        elif isinstance(obj, np.ndarray):
            return obj.tolist()
        elif isinstance(obj, dict):
            return {k: convert_to_serializable(v) for k, v in obj.items()}
        elif isinstance(obj, list):
            return [convert_to_serializable(item) for item in obj]
        return obj
    
    serializable_metrics = convert_to_serializable(metrics)
    
    with open(json_path, 'w') as f:
        json.dump(serializable_metrics, f, indent=2)


def print_summary(metrics: dict, y_test):
    """Print evaluation summary."""
    print("\n" + "=" * 70)
    print("EVALUATION SUMMARY")
    print("=" * 70)
    
    report_dict = metrics['classification_report']
    
    print(f"\nTotal Test Samples: {len(y_test)}")
    print(f"Accuracy: {metrics['accuracy']:.4f}")
    print(f"Macro F1-Score: {metrics['macro_f1']:.4f}")
    print(f"Weighted F1-Score: {metrics['weighted_f1']:.4f}")
    
    # Extract per-class F1 scores (excluding summary rows)
    class_f1_scores = []
    for class_name, class_metrics in report_dict.items():
        if isinstance(class_metrics, dict) and 'f1-score' in class_metrics:
            class_f1_scores.append((
                class_name,
                class_metrics['f1-score'],
                class_metrics.get('support', 0)
            ))
    
    # Sort by F1-score
    class_f1_scores.sort(key=lambda x: x[1], reverse=True)
    
    # Top 5 best-performing classes
    print("\n" + "-" * 70)
    print("Top 5 Best-Performing Classes (by F1-Score):")
    print("-" * 70)
    for i, (class_name, f1, support) in enumerate(class_f1_scores[:5], 1):
        print(f"  {i}. {class_name:<30} F1: {f1:.4f}  Support: {support:.0f}")
    
    # Bottom 5 worst-performing classes
    print("\n" + "-" * 70)
    print("Bottom 5 Worst-Performing Classes (by F1-Score):")
    print("-" * 70)
    for i, (class_name, f1, support) in enumerate(class_f1_scores[-5:], 1):
        print(f"  {i}. {class_name:<30} F1: {f1:.4f}  Support: {support:.0f}")
    
    print("\n" + "=" * 70)


def main():
    """Main evaluation pipeline."""
    print("=" * 70)
    print("FINAL BASELINE MODEL EVALUATION")
    print("=" * 70)
    
    # Define paths
    project_root = Path(__file__).parent.parent.parent
    data_path = project_root / "data" / "processed" / "step4_cleaned_text.csv"
    
    # Try multiple model locations
    model_path = project_root / "models" / "baseline" / "model.joblib"
    vectorizer_path = project_root / "models" / "baseline" / "vectorizer.joblib"
    
    # Fallback to backend artifacts if baseline models not found
    if not model_path.exists():
        model_path = project_root / "backend" / "artifacts" / "model.joblib"
    if not vectorizer_path.exists():
        vectorizer_path = project_root / "backend" / "artifacts" / "vectorizer.joblib"
    
    output_dir = project_root / "evaluation" / "results"
    
    # Verify files exist
    if not data_path.exists():
        print(f"\nERROR: Dataset not found at: {data_path}")
        print("Please ensure the processed dataset exists at:")
        print("  data/processed/step4_cleaned_text.csv")
        print("\nThis file should contain:")
        print("  - 'summary' column: cleaned complaint text")
        print("  - Label column: target fault labels")
        raise FileNotFoundError(f"Dataset not found: {data_path}")
    
    if not model_path.exists():
        raise FileNotFoundError(f"Model not found at: {model_path}")
    if not vectorizer_path.exists():
        raise FileNotFoundError(f"Vectorizer not found at: {vectorizer_path}")
    
    print(f"Using model: {model_path}")
    print(f"Using vectorizer: {vectorizer_path}")
    
    # Load dataset
    df = load_dataset(str(data_path))
    
    # Determine target column (usually 'label' or similar)
    # Check common column names
    possible_target_cols = ['label', 'Label', 'LABEL', 'target', 'fault', 'category']
    target_col = None
    for col in possible_target_cols:
        if col in df.columns:
            target_col = col
            break
    
    if target_col is None:
        # If not found, assume it's the last column or show available
        print(f"\nAvailable columns: {list(df.columns)}")
        raise ValueError("Could not determine target column. Please specify.")
    
    print(f"\nUsing target column: {target_col}")
    
    # Load model artifacts
    model, vectorizer = load_model_artifacts(str(model_path), str(vectorizer_path))
    
    # Split data (80/20 stratified, random_state=42)
    X_train, X_test, y_train, y_test = split_data(df, target_col, random_state=42)
    
    # Evaluate on test set
    y_pred, y_proba, metrics = evaluate_model(model, vectorizer, X_test, y_test)
    
    # Save results
    save_results(metrics, y_test, y_pred, output_dir)
    
    # Print summary
    print_summary(metrics, y_test)
    
    print("\nEvaluation complete!")


if __name__ == "__main__":
    main()

