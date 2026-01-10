# Backend Integration Analysis & Design

**Generated:** $(date)  
**Purpose:** Complete analysis of frontend structure and backend integration plan for AI-Based Automotive Fault Detection System

---

## ================================
## PHASE 1 — FRONTEND ANALYSIS
## ================================

### 1. Repository Structure Summary

The frontend repository is a **Flutter (Dart)** mobile application with the following structure:

```
frontend/
├── lib/
│   ├── features/
│   │   └── diagnose/          # Core diagnosis feature
│   │       ├── controllers/   # State management
│   │       ├── handlers/      # Business logic & API calls
│   │       ├── widgets/       # UI components
│   │       └── theme/         # Styling
│   ├── models/                # Data models
│   ├── services/              # API services
│   ├── screens/               # Screen widgets
│   └── utils/                 # Utilities
├── android/                   # Android platform files
├── ios/                       # iOS platform files
├── web/                       # Web platform files
└── pubspec.yaml              # Flutter dependencies
```

### 2. Frontend Framework

- **Framework:** Flutter (Dart SDK ^3.7.2)
- **HTTP Library:** `http: ^1.2.0` (package:http)
- **Platform Support:** Android, iOS, Web, Windows, Linux, macOS

### 3. API Communication Details

#### Service Location
- **File:** `frontend/lib/services/diagnosis_service.dart`
- **Class:** `DiagnosisService`

#### Current API Configuration
```dart
static const String baseUrl = 'http://localhost:8000';
static const String endpoint = '/api/diagnose';
static const Duration timeout = Duration(seconds: 30);
```

#### Request Format
- **Method:** POST
- **Headers:** `Content-Type: application/json`
- **Request Body:**
```json
{
  "complaint": "Engine is shaking when idling."
}
```

#### Expected Response Format
The frontend expects a JSON response with the following structure:

```json
{
  "issues": [
    {
      "name": "Fault Name (e.g., 'Engine Misfire')",
      "confidence": 0.85,
      "severity": "critical" | "warning"
    }
  ],
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

### 4. Data Models

#### DiagnosisResult Model (`diagnosis_result_model.dart`)
```dart
class DiagnosisResult {
  final List<DiagnosedIssue> issues;
  final DateTime timestamp;
}

class DiagnosedIssue {
  final String name;           // Fault name
  final double confidence;     // 0.0 to 1.0 (converted to percentage on frontend)
  final IssueSeverity severity; // critical | warning
}

enum IssueSeverity {
  critical,
  warning
}
```

#### Key Frontend Behaviors
1. **Sorting:** Frontend automatically sorts issues by confidence (highest first)
2. **Display:** All issues in the response are displayed
3. **Confidence:** Stored as 0.0-1.0, displayed as percentage (0-100%)
4. **Severity Mapping:**
   - `"critical"` or `"high"` → `IssueSeverity.critical`
   - `"warning"`, `"medium"`, `"low"`, `"info"`, or default → `IssueSeverity.warning`

### 5. API Call Flow

1. User enters complaint text in `MessageInput` widget
2. User clicks send button → `DiagnoseHandlers.onSend()` is triggered
3. Handler calls `DiagnosisService.diagnoseComplaint(complaint)`
4. Service makes POST request to `http://localhost:8000/api/diagnose`
5. Response is parsed into `DiagnosisResult` object
6. Issues are sorted by confidence (backend should provide top-3, but frontend handles sorting)
7. Results are displayed in `DiagnosisResultWidget`

### 6. Error Handling

The frontend handles:
- Network errors (`http.ClientException`)
- Invalid JSON format (`FormatException`)
- HTTP status codes != 200
- Timeout errors (30 seconds)

All errors are caught and displayed via the controller's error state.

### 7. Summary: Frontend-Backend Communication

**How frontend expects to communicate:**
- RESTful API over HTTP
- JSON request/response format
- Synchronous request-response pattern
- Single endpoint for diagnosis: `POST /api/diagnose`

**What data format frontend needs:**
- **Input:** Natural language complaint string
- **Output:** Array of diagnosed issues with:
  - Issue name (string)
  - Confidence score (float 0.0-1.0)
  - Severity level (string: "critical" or "warning")
- Timestamp (ISO8601 string) - optional but recommended

**Key Requirements:**
- Top-3 predictions (frontend can handle more, but top-3 is standard)
- Confidence scores between 0.0 and 1.0
- Severity classification (critical/warning)

---

## ================================
## PHASE 2 — BACKEND INTEGRATION PLAN
## ================================

### 1. Backend API Design

#### Endpoint Specification

**Endpoint:** `POST /api/diagnose`

**Request Schema:**
```json
{
  "complaint": "string (required, non-empty)"
}
```

**Request Validation:**
- `complaint` must be a non-empty string
- Maximum length: 500 characters (recommended)

**Response Schema:**
```json
{
  "issues": [
    {
      "name": "string",
      "confidence": 0.0-1.0,
      "severity": "critical" | "warning"
    }
  ],
  "timestamp": "ISO8601 datetime string",
  "suppression_applied": {
    "unknown_suppressed": boolean,
    "other_suppressed": boolean
  }
}
```

### 2. Request Example

```json
POST /api/diagnose
Content-Type: application/json

{
  "complaint": "Engine is shaking when idling and making strange noises."
}
```

### 3. Response Example

**Success Response (200 OK):**
```json
{
  "issues": [
    {
      "name": "Engine Misfire",
      "confidence": 0.92,
      "severity": "critical"
    },
    {
      "name": "Worn Engine Mounts",
      "confidence": 0.78,
      "severity": "warning"
    },
    {
      "name": "Ignition System Problem",
      "confidence": 0.65,
      "severity": "warning"
    }
  ],
  "timestamp": "2024-01-15T10:30:00.123456Z",
  "suppression_applied": {
    "unknown_suppressed": false,
    "other_suppressed": true
  }
}
```

**Error Response (400 Bad Request):**
```json
{
  "detail": "Complaint cannot be empty"
}
```

**Error Response (422 Unprocessable Entity):**
```json
{
  "detail": [
    {
      "loc": ["body", "complaint"],
      "msg": "ensure this value has at least 1 characters",
      "type": "value_error.any_str.min_length"
    }
  ]
}
```

### 4. API Contract Details

#### Top-3 Predictions
- Backend must return **exactly 3 predictions** (or fewer if model has less than 3 classes)
- Predictions must be sorted by confidence (highest first)
- If fewer than 3 predictions available, return all available

#### Confidence Scores
- Range: `0.0` to `1.0` (inclusive)
- Represent model prediction probability
- Must be float/double precision

#### Severity Classification
- **"critical":** For serious faults requiring immediate attention
- **"warning":** For less critical issues or potential problems
- Classification logic should be part of the backend (can be based on confidence thresholds or label mapping)

#### Suppression Flags
- **`unknown_suppressed`:** Boolean indicating if "UNKNOWN" class was filtered out
- **`other_suppressed`:** Boolean indicating if "OTHER" class was filtered out
- These flags help with model explainability and debugging

### 5. API Endpoints Summary

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/diagnose` | POST | Main diagnosis endpoint |
| `/health` | GET | Health check (optional, recommended) |
| `/api/docs` | GET | FastAPI auto-generated docs (optional) |

### 6. CORS Configuration

Since frontend runs on different ports (Flutter web may use localhost with different port), backend must:
- Enable CORS
- Allow origins: `*` (development) or specific origins (production)
- Allow methods: `POST`, `GET`, `OPTIONS`
- Allow headers: `Content-Type`

---

## ================================
## PHASE 3 — BACKEND REPOSITORY STRUCTURE
## ================================

### 1. Proposed Folder Structure

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                 # FastAPI application entry point
│   ├── api/
│   │   ├── __init__.py
│   │   ├── routes/
│   │   │   ├── __init__.py
│   │   │   └── diagnose.py     # Diagnosis endpoint
│   │   └── schemas/
│   │       ├── __init__.py
│   │       ├── request.py      # Request schemas (Pydantic)
│   │       └── response.py     # Response schemas (Pydantic)
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py           # Configuration settings
│   │   └── exceptions.py       # Custom exception handlers
│   ├── models/
│   │   ├── __init__.py
│   │   └── predictor.py        # ML model predictor class
│   ├── preprocessing/
│   │   ├── __init__.py
│   │   └── text_cleaner.py     # clean_text function (reused from ML)
│   └── utils/
│       ├── __init__.py
│       └── suppression.py      # Confidence-aware suppression logic
├── artifacts/                  # Trained model artifacts (GITIGNORED)
│   ├── model.joblib           # Trained classifier model
│   └── vectorizer.joblib      # Trained text vectorizer
├── requirements.txt           # Python dependencies
├── .env.example              # Environment variables template
├── .gitignore
└── README.md                 # Backend documentation
```

### 2. File Responsibilities

#### `app/main.py`
- FastAPI application initialization
- CORS middleware configuration
- Route registration
- Exception handlers
- Application startup/shutdown events (model loading)

#### `app/api/routes/diagnose.py`
- POST `/api/diagnose` endpoint implementation
- Request validation
- Call to predictor service
- Response formatting
- Error handling

#### `app/api/schemas/request.py`
- Pydantic models for request validation:
  - `DiagnosisRequest`: `{ complaint: str }`

#### `app/api/schemas/response.py`
- Pydantic models for response:
  - `DiagnosedIssue`: `{ name, confidence, severity }`
  - `SuppressionInfo`: `{ unknown_suppressed, other_suppressed }`
  - `DiagnosisResponse`: `{ issues, timestamp, suppression_applied }`

#### `app/core/config.py`
- Configuration management
- Environment variables (API port, model paths, etc.)
- Default settings

#### `app/core/exceptions.py`
- Custom exception classes
- HTTP exception handlers
- Error response formatting

#### `app/models/predictor.py`
- `Predictor` class that:
  - Loads `model.joblib` and `vectorizer.joblib` at startup
  - Provides `predict()` method:
    - Takes complaint string
    - Applies text cleaning
    - Vectorizes text
    - Runs model prediction
    - Applies suppression logic
    - Returns top-3 predictions with confidence

#### `app/preprocessing/text_cleaner.py`
- Reused `clean_text()` function from ML workspace
- Text normalization and cleaning logic
- Must match ML training preprocessing exactly

#### `app/utils/suppression.py`
- Confidence-aware suppression logic
- Filters out "UNKNOWN" and "OTHER" classes based on confidence thresholds
- Returns suppression flags for transparency

#### `artifacts/` (directory)
- Contains trained model files
- **Must be gitignored** (add to `.gitignore`)
- Models are loaded from this directory at runtime

### 3. Key Implementation Notes

#### Model Loading Strategy
- Models should be loaded **once** at application startup
- Store loaded models in application state (FastAPI lifespan events)
- Reuse loaded models for all inference requests (thread-safe)

#### Preprocessing Consistency
- **Critical:** Use **exact same** `clean_text()` function as ML training
- Copy the function from ML workspace to ensure consistency
- Any differences will cause prediction drift

#### Suppression Logic
- Implement confidence thresholds:
  - If top prediction is "UNKNOWN" with confidence < threshold → suppress
  - If top prediction is "OTHER" with confidence < threshold → suppress
- Track which suppressions were applied for API response

#### Severity Mapping
- Can be based on:
  - Confidence thresholds (e.g., >0.8 = critical, else warning)
  - Label-based mapping (if fault names indicate severity)
  - Hybrid approach

### 4. Dependencies (requirements.txt)

```
fastapi==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.5.0
pydantic-settings==2.1.0
joblib==1.3.2
scikit-learn==1.3.2
numpy==1.26.2
python-multipart==0.0.6
```

### 5. Environment Variables (.env.example)

```env
# API Configuration
API_HOST=0.0.0.0
API_PORT=8000

# Model Paths
MODEL_PATH=artifacts/model.joblib
VECTORIZER_PATH=artifacts/vectorizer.joblib

# Suppression Thresholds
UNKNOWN_SUPPRESSION_THRESHOLD=0.5
OTHER_SUPPRESSION_THRESHOLD=0.5

# CORS (Development)
CORS_ORIGINS=*

# Logging
LOG_LEVEL=INFO
```

---

## ================================
## MODEL MIGRATION INSTRUCTIONS
## ================================

### How to Move Trained Models from ML Repo to Backend Repo

#### Step 1: Locate Trained Artifacts in ML Repository

1. Navigate to your ML workspace directory
2. Find the trained model files:
   - `model.joblib` (trained classifier)
   - `vectorizer.joblib` (trained text vectorizer)

These files are typically located in:
- `ml/models/` directory
- `ml/artifacts/` directory
- Or wherever your ML training script saved them

#### Step 2: Copy Artifacts to Backend

```bash
# From project root
cp ml/models/model.joblib backend/artifacts/model.joblib
cp ml/models/vectorizer.joblib backend/artifacts/vectorizer.joblib
```

**OR** if artifacts are in a different location:

```bash
# Adjust paths as needed
cp <ml_path>/model.joblib backend/artifacts/model.joblib
cp <ml_path>/vectorizer.joblib backend/artifacts/vectorizer.joblib
```

#### Step 3: Verify File Existence

```bash
# Check that files exist
ls -lh backend/artifacts/
# Should show:
# - model.joblib
# - vectorizer.joblib
```

#### Step 4: Copy Preprocessing Function

1. Locate `clean_text()` function in ML workspace
2. Copy the exact function to `backend/app/preprocessing/text_cleaner.py`
3. Ensure all imports are included
4. **Verify function signature and logic match exactly**

#### Step 5: Copy Suppression Logic (if exists)

1. If suppression logic exists in ML workspace, copy it to `backend/app/utils/suppression.py`
2. Ensure confidence thresholds match training configuration
3. If suppression logic doesn't exist, implement based on requirements

#### Step 6: Update .gitignore

Ensure `backend/.gitignore` includes:

```
# Model artifacts (too large for git)
artifacts/*.joblib
artifacts/*.pkl
artifacts/*.h5
```

**Note:** Model files should NOT be committed to git repository due to size.

#### Step 7: Document Model Version

Create `backend/artifacts/README.md`:

```markdown
# Model Artifacts

This directory contains trained model artifacts exported from the ML workspace.

## Files

- `model.joblib`: Trained classifier model
- `vectorizer.joblib`: Trained text vectorizer

## Version

- Model Version: [e.g., v1.0.0]
- Training Date: [e.g., 2024-01-15]
- ML Workspace Commit: [git commit hash if applicable]

## Usage

These files are loaded automatically by the backend at startup.
Do not modify these files manually.
```

### Verification Checklist

- [ ] `backend/artifacts/model.joblib` exists and is readable
- [ ] `backend/artifacts/vectorizer.joblib` exists and is readable
- [ ] `clean_text()` function is copied and matches ML version exactly
- [ ] Suppression logic is implemented or copied
- [ ] `.gitignore` excludes model artifacts
- [ ] Model paths are configured in `.env` or `config.py`

---

## ================================
## NEXT STEPS
## ================================

### After This Analysis

1. **Backend Implementation:**
   - Create the folder structure
   - Implement FastAPI application
   - Integrate model loading
   - Implement preprocessing
   - Create API endpoints

2. **Testing:**
   - Unit tests for preprocessing
   - Unit tests for suppression logic
   - Integration tests for API endpoints
   - Test with real model artifacts

3. **Frontend-Backend Integration:**
   - Update frontend base URL if needed (currently `localhost:8000`)
   - Test end-to-end flow
   - Handle CORS if testing from web platform

4. **Deployment:**
   - Configure production environment variables
   - Set up proper CORS origins
   - Deploy backend service
   - Update frontend API URLs for production

---

## Summary

This document provides:
1. ✅ Complete frontend analysis (Flutter/Dart, API expectations)
2. ✅ Detailed backend API design (request/response schemas)
3. ✅ Clean backend repository structure (FastAPI, inference-only)
4. ✅ Step-by-step model migration instructions

The backend design aligns perfectly with frontend expectations while supporting:
- Natural language complaint input
- Top-3 predictions with confidence scores
- Suppression flags for transparency
- Clean, maintainable code structure

**Ready for backend implementation phase!** 🚀

