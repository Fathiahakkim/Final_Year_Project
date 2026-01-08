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

