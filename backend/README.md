# Backend

## Purpose

Backend inference service (API) that loads trained ML models and serves predictions for automotive fault detection.

## Responsibilities

- **Model Loading**: Load trained ML models exported from the ML workspace
- **Inference Serving**: Process requests and return predictions
- **API Endpoints**: Provide RESTful API endpoints for the frontend

## Scope Limitations

This component does **NOT** include:
- Model training code
- Frontend UI logic

## Development Notes

- Receive trained models from the ML workspace
- Focus on efficient model serving and inference
- Provide clean API interfaces for frontend consumption

## Setup Instructions

### 1. Install Dependencies

```bash
cd backend
pip install -r requirements.txt
```

### 2. Environment Configuration

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` to configure your settings (currently using defaults is fine for development).

### 3. Create Artifacts Directory

```bash
mkdir -p artifacts
```

**Note:** Model files (`model.joblib` and `vectorizer.joblib`) will be placed in this directory after training.

### 4. Run the Development Server

```bash
uvicorn app.main:app --reload
```

The API will be available at:
- API: http://localhost:8000
- Interactive Docs: http://localhost:8000/docs
- Health Check: http://localhost:8000/health

### 5. Test the API

The `/api/diagnose` endpoint is currently returning dummy data. Test it with:

```bash
curl -X POST "http://localhost:8000/api/diagnose" \
  -H "Content-Type: application/json" \
  -d '{"complaint": "Engine is shaking when idling."}'
```

## Project Structure

```
backend/
├── app/
│   ├── main.py              # FastAPI application entry point
│   ├── api/
│   │   ├── routes/         # API route handlers
│   │   └── schemas/        # Pydantic request/response models
│   ├── core/               # Core configuration
│   ├── models/             # ML model predictor (placeholder)
│   ├── preprocessing/      # Text preprocessing (placeholder)
│   └── utils/              # Utility functions (placeholder)
├── artifacts/              # Model files directory (gitignored)
├── requirements.txt        # Python dependencies
└── .env.example           # Environment variables template
```

## Next Steps

1. Copy trained models from ML workspace to `artifacts/` directory
2. Implement `clean_text()` in `app/preprocessing/text_cleaner.py`
3. Implement model loading in `app/models/predictor.py`
4. Implement suppression logic in `app/utils/suppression.py`
5. Integrate all components in the diagnosis route

