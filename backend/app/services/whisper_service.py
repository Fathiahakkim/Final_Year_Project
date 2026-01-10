"""Whisper service for speech-to-text transcription."""
import whisper
import logging
from typing import Optional

logger = logging.getLogger(__name__)


class WhisperService:
    """Service for Whisper-based speech-to-text transcription.
    
    Loads the Whisper model lazily on first transcription call.
    Uses the 'large' model for highest accuracy with fp16=False for CPU compatibility.
    """
    
    def __init__(self, model_name: str = "large", fp16: bool = False):
        """Initialize Whisper service.
        
        Args:
            model_name: Whisper model name (default: "large")
            fp16: Whether to use fp16 precision (default: False for CPU compatibility)
        """
        self.model_name = model_name
        self.fp16 = fp16
        self.model: Optional[whisper.Whisper] = None
    
    def _load_model(self) -> None:
        """Load the Whisper model if not already loaded."""
        if self.model is not None:
            return
            
        try:
            logger.info(f"Loading Whisper model: {self.model_name} (fp16={self.fp16})")
            self.model = whisper.load_model(self.model_name)
            logger.info(f"Successfully loaded Whisper model: {self.model_name}")
        except Exception as e:
            logger.error(f"Failed to load Whisper model: {e}")
            raise
    
    def transcribe(self, audio_path: str) -> str:
        """Transcribe audio file to text.
        
        Loads the Whisper model on first call if not already loaded.
        
        Args:
            audio_path: Path to the audio file (WAV format expected)
            
        Returns:
            Transcribed text string
            
        Raises:
            ValueError: If model fails to load or audio file is invalid
            FileNotFoundError: If audio file does not exist
        """
        # Load model if not already loaded (lazy loading)
        self._load_model()
        
        try:
            logger.info(f"Transcribing audio file: {audio_path}")
            result = self.model.transcribe(
                audio_path,
                fp16=self.fp16,
                language="en"  # Optional: specify language for better accuracy
            )
            
            transcribed_text = result["text"].strip()
            logger.info(f"Transcription completed. Text length: {len(transcribed_text)} characters")
            logger.info(f"Transcribed text: {transcribed_text}")
            
            return transcribed_text
        except FileNotFoundError:
            logger.error(f"Audio file not found: {audio_path}")
            raise
        except Exception as e:
            logger.error(f"Error during transcription: {e}")
            raise ValueError(f"Transcription failed: {e}")
