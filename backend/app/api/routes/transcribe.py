from fastapi import APIRouter, UploadFile, File, HTTPException
import os
import tempfile
import logging

router = APIRouter()
logger = logging.getLogger(__name__)


@router.post("/api/v1/transcribe")
async def transcribe_audio(file: UploadFile = File(...)):
    logger.info(f"Received file: {file.filename}")

    # ALWAYS accept the file (ignore content-type)
    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as tmp:
            audio_bytes = await file.read()
            tmp.write(audio_bytes)
            audio_path = tmp.name

        logger.info(f"Saved audio file to: {audio_path}")
        logger.info(f"File size: {len(audio_bytes)} bytes")

        from app.main import app
        whisper_service = app.state.whisper_service

        if whisper_service is None:
            raise HTTPException(status_code=500, detail="Whisper service not loaded")

        text = whisper_service.transcribe(audio_path)
        logger.info(f"Transcription result: {text}")

        return {"text": text}

    except Exception as e:
        logger.exception("Transcription failed")
        raise HTTPException(status_code=500, detail=str(e))

    finally:
        if os.path.exists(audio_path):
            os.remove(audio_path)
