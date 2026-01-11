# Voice-to-Text Pipeline

## Overview
Separate, isolated voice-to-text pipeline that converts speech to text. This is a parallel input modality that does NOT modify existing diagnose logic.

## Architecture

```
features/voice/
├── voice_permission.dart      # Mic permission only
├── speech_service.dart        # speech_to_text wrapper
├── voice_controller.dart      # State + coordination
└── voice_mic_button.dart      # UI only (later)
```

## File Responsibilities

| File | Responsibility | Dependencies |
|------|---------------|--------------|
| `voice_permission.dart` | Microphone permission handling | permission_handler package |
| `speech_service.dart` | Speech-to-text conversion | speech_to_text package |
| `voice_controller.dart` | State management & coordination | voice_permission, speech_service |
| `voice_mic_button.dart` | UI component | voice_controller |

## Data Flow

```
User taps button
    ↓
voice_mic_button.dart → calls voice_controller.startListening()
    ↓
voice_controller.dart → checks voice_permission.dart
    ↓
voice_permission.dart → returns permission status
    ↓
voice_controller.dart → starts speech_service.dart
    ↓
speech_service.dart → listens & converts speech to text
    ↓
speech_service.dart → returns text to voice_controller
    ↓
voice_controller.dart → emits text via Stream<String>
    ↓
External consumer (e.g., diagnose) → receives text, updates textbox
```

## Integration Points

- **Input**: User interaction via `voice_mic_button.dart`
- **Output**: Text via `voice_controller.textStream`
- **No backend calls**: Pipeline only produces text
- **Isolated**: Can be removed without breaking app

## Rules

- ✅ Voice folder outputs TEXT only
- ✅ Voice folder does NOT call backend APIs
- ✅ Voice folder does NOT know about diagnose logic
- ✅ One file = one responsibility
- ✅ Diagnose can import `voice_mic_button.dart` and listen to `voice_controller.textStream`
