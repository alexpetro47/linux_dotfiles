# Voice Scripts

Voice dictation system with non-blocking recording and background transcription.

## voice-dictation

Main controller for voice input.

**Location:** `new-machine-setup/voice-dictation`

**Usage:**
```bash
voice-dictation     # Or: Mod+v
```

**First press:** Start recording
**Second press:** Stop recording, start transcription
**Mod+Shift+v:** Cancel recording

**How it works:**

1. **Start recording:**
   - Captures current terminal/tmux pane ID
   - Starts `sox` recording (16kHz mono WAV)
   - Stores PID for stop control
   - Updates polybar (red mic icon)

2. **Stop recording:**
   - Kills sox process
   - Spawns background transcription worker
   - Updates polybar (green gear icon)

**Temp files:**
| File | Purpose |
|------|---------|
| `/tmp/voice-dictation-*.wav` | Audio recording |
| `/tmp/voice-dictation-pane` | tmux pane ID |
| `/tmp/voice-dictation-pid` | sox process ID |

## voice-dictation-transcribe

Background worker for speech-to-text.

**Location:** `new-machine-setup/voice-dictation-transcribe`

**Usage:**
Called automatically by `voice-dictation`. Not meant for direct use.

**Process:**
1. Reads audio file path from arguments
2. Runs `whisper-ctranslate2` transcription
3. Gets target terminal from state files
4. Types output using `xdotool`
5. Cleans up temp files
6. Updates polybar (clears icon)

**Transcription:**
Uses `whisper-ctranslate2` with configured model size.

## Dependencies

| Tool | Purpose | Install |
|------|---------|---------|
| `sox` | Audio recording | APT |
| `whisper-ctranslate2` | Transcription | uv |
| `xdotool` | Typing output | APT |

All installed via `install-packages.sh`.

## Polybar Integration

IPC module `voice-dictation` shows status:

| State | Icon | Color |
|-------|------|-------|
| Idle | None | - |
| Recording | Mic | Red |
| Transcribing | Gear | Green |

Update commands:
```bash
polybar-msg action voice-dictation send ""          # Clear
polybar-msg action voice-dictation send "recording" # Recording
polybar-msg action voice-dictation send "transcribing" # Transcribing
```

## Terminal Isolation

The system tracks which terminal started recording:

**For tmux:**
```bash
tmux display-message -p '#{pane_id}'
```

**For X11 windows:**
```bash
xdotool getactivewindow
```

Output is typed into the correct terminal regardless of current focus.

## Configuration

### Audio Settings

In `voice-dictation`:
```bash
SAMPLE_RATE=16000
CHANNELS=1
FORMAT=wav
```

### Whisper Model

In `voice-dictation-transcribe`:
```bash
MODEL=base  # tiny, base, small, medium, large
```

Larger models = better accuracy, slower transcription.

## Troubleshooting

**No recording:**
```bash
# Test sox directly
sox -d /tmp/test.wav
# Check microphone
pactl list sources short
```

**Transcription fails:**
```bash
# Test whisper directly
whisper-ctranslate2 /tmp/test.wav
```

**Wrong terminal output:**
- Ensure recording started from target terminal
- Check state files exist

**Stuck polybar icon:**
```bash
polybar-msg action voice-dictation send ""
```
