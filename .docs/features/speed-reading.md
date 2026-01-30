# Speed Reading

RSVP (Rapid Serial Visual Presentation) tools for consuming text at accelerated rates. Multiple presentation modes available.

## Tools

| Script | Description |
|--------|-------------|
| `speedread-clipboard` | Read clipboard contents with RSVP |
| `speedread-popup` | Popup window reader |
| `speedread-tui` | Terminal UI version |
| `speedread-keys` | Keyboard-controlled reader |

## Usage

### Clipboard Reader

```bash
# Copy text, then:
speedread-clipboard
```

Reads clipboard contents word-by-word at configured WPM.

### Popup Reader

```bash
speedread-popup
```

Opens floating window for RSVP display.

### TUI Reader

```bash
speedread-tui
```

Full terminal interface with controls.

### Keyboard-Controlled

```bash
speedread-keys
```

Read with keyboard controls for speed/pause.

## How RSVP Works

RSVP displays words one at a time at a fixed point, eliminating eye movement:

1. Text is split into words
2. Each word displayed for calculated duration
3. Focus point (ORP - Optimal Recognition Point) highlighted
4. Reader's eye stays fixed

Benefits:
- Eliminates saccades (eye jumps)
- Reduces subvocalization
- Increases reading speed

## Configuration

Speed (WPM) and other settings configured in scripts.

Typical ranges:
- 250 WPM: Comfortable comprehension
- 400 WPM: Trained reader
- 600+ WPM: Speed reading with practice

## Dependencies

Built on `speedread` or similar RSVP engine.

## Location

Scripts in `new-machine-setup/`, symlinked to `~/.local/bin/`.

## Future Plans

- Integration with voice dictation output
- Article/URL reader
- Progress persistence
