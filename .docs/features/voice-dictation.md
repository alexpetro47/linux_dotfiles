# Voice Dictation

Non-blocking voice input system with background transcription. Records audio via `sox`, transcribes with `whisper-ctranslate2`, and outputs to the originating terminal.

## Quick Usage

| Key | Action |
|-----|--------|
| `Mod+v` | Start/stop recording |
| `Mod+Shift+v` | Cancel recording |

## How It Works

### Recording Phase

1. `Mod+v` triggers `voice-dictation` script
2. Captures originating terminal/tmux pane
3. Starts `sox` recording (16kHz mono WAV)
4. Polybar shows red recording indicator

### Transcription Phase

1. Second `Mod+v` stops recording
2. Spawns background `voice-dictation-transcribe` worker
3. Polybar shows green transcribing indicator
4. Worker runs `whisper-ctranslate2` on audio
5. Output typed into original terminal

### Terminal Isolation

The system tracks which terminal started the recording:
- For tmux: Captures pane ID
- For regular terminals: Captures window ID
- Transcription output goes to correct location

## Scripts

### `voice-dictation`

Main controller script.

Location: `new-machine-setup/voice-dictation`

Functions:
- Toggle recording on/off
- Launch transcription worker
- Update polybar status
- Handle cancellation

### `voice-dictation-transcribe`

Background transcription worker.

Location: `new-machine-setup/voice-dictation-transcribe`

Functions:
- Run whisper on recorded audio
- Send output to correct terminal
- Clean up temp files
- Update polybar status

## Dependencies

| Tool | Purpose |
|------|---------|
| `sox` | Audio recording |
| `whisper-ctranslate2` | Speech-to-text |
| `xdotool` | Typing output |

Installed via `install-packages.sh`.

## Configuration

### Audio Settings

Recording parameters (in `voice-dictation`):
- Sample rate: 16000 Hz
- Channels: Mono
- Format: WAV

### Whisper Model

Default model set in transcribe script. Can use:
- `tiny` - Fastest, less accurate
- `base` - Good balance
- `small` - Better accuracy
- `medium` - High accuracy
- `large` - Best accuracy, slowest

## Polybar Integration

Status module in polybar shows:
- No icon: Idle
- Red mic: Recording
- Green gear: Transcribing

Module: `voice-dictation` (IPC-enabled)

## Temp Files

| File | Purpose |
|------|---------|
| `/tmp/voice-dictation-*.wav` | Audio recording |
| `/tmp/voice-dictation-pane` | tmux pane ID |
| `/tmp/voice-dictation-pid` | Recording process ID |

Cleaned up after transcription completes.

## Troubleshooting

**No audio recorded:**
```bash
# Check sox works
sox -d test.wav  # Should record

# Check microphone
pactl list sources short
```

**Transcription fails:**
```bash
# Test whisper directly
whisper-ctranslate2 /tmp/test.wav
```

**Output goes to wrong terminal:**
- Ensure recording started from target terminal
- Check tmux pane ID captured correctly

**Polybar icon stuck:**
```bash
# Reset status
polybar-msg action voice-dictation send ""
```

## Future Plans

- TTS playback via Piper
- Speed reading integration
- Multiple transcription backends
