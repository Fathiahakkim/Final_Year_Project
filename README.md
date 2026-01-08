# AI-Based Automotive Fault Detection Project

## Project Overview

This project is an AI-powered system for detecting and diagnosing automotive faults. The system enables users to describe vehicle issues and receive intelligent fault detection and diagnostic suggestions.

## Development Approach

The project follows a **level-based development approach** to incrementally build capabilities:

- **Level 1: Text-based NLP** - Initial implementation using natural language processing for text-based fault descriptions
- **Level 2: Voice input** - Extend the system to support voice-based input for fault descriptions
- **Level 3: Explainability & Context** - Add explainability features and contextual understanding for more accurate diagnoses

## Project Structure

This repository is organized into three main components to enable parallel development:

### Frontend (`/frontend`)

Flutter-based mobile application that handles user interface, navigation, state management, and API integration.

### Backend (`/backend`)

API service that loads trained ML models and serves predictions/inference requests.

### ML (`/ml`)

Offline machine learning workspace for dataset preparation, feature extraction, model training, and model export.

## Team Workflow

The project structure supports parallel development:

- Frontend and backend teams can work independently
- ML team trains and exports models separately
- Clear separation of concerns ensures minimal conflicts

## Responsibilities

Each component has distinct responsibilities:

- **Frontend**: UI/UX, user interaction, API communication
- **Backend**: Model loading, inference serving, API endpoints
- **ML**: Data processing, model training, model artifacts

See individual component READMEs for detailed responsibilities.
