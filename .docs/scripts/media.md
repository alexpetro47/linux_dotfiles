# Media Scripts

Speed reading utilities and content consumption tools.

## Speed Reading Tools

RSVP (Rapid Serial Visual Presentation) displays words one at a time, eliminating eye movement for faster reading.

### speedread-clipboard

Read clipboard contents with RSVP.

**Location:** `new-machine-setup/speedread-clipboard`

**Usage:**
```bash
# Copy text to clipboard, then:
speedread-clipboard
```

**Workflow:**
1. Gets clipboard content via `xclip`
2. Pipes to RSVP engine
3. Displays words sequentially

### speedread-popup

Popup window for RSVP display.

**Location:** `new-machine-setup/speedread-popup`

**Usage:**
```bash
speedread-popup
```

Opens floating window for word display.

### speedread-tui

Terminal UI reader with controls.

**Location:** `new-machine-setup/speedread-tui`

**Usage:**
```bash
speedread-tui
```

Full terminal interface with:
- Speed control
- Pause/resume
- Progress indication

### speedread-keys

Keyboard-controlled reader.

**Location:** `new-machine-setup/speedread-keys`

**Usage:**
```bash
speedread-keys
```

**Controls:**
- Space: Pause/resume
- Up/Down: Speed adjustment
- q: Quit

## Speed Settings

Typical WPM (words per minute):

| WPM | Description |
|-----|-------------|
| 200-250 | Normal reading |
| 300-400 | Comfortable speed reading |
| 500-600 | Trained reader |
| 700+ | Expert with practice |

## How RSVP Works

1. Text split into words
2. Each word displayed at fixed position
3. Focus point highlighted (ORP - Optimal Recognition Point)
4. Eye stays stationary

**Benefits:**
- No saccades (eye jumps between words)
- Reduced subvocalization
- Consistent reading pace

## Dependencies

Speed reading tools typically depend on:
- `xclip` - Clipboard access
- RSVP engine (varies by implementation)

## Future Plans

- Voice dictation integration (hear transcription via TTS, or speed-read it)
- URL/article reader
- Progress persistence
- Mobile-friendly popup
