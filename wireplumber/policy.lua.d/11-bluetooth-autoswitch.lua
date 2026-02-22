-- Override bluetooth auto-switch policy to include SoX (voice-dictation)
-- Extends the default application list from 10-default-policy.lua
bluetooth_policy.policy["media-role.applications"] = {
  -- Default apps
  "Firefox", "Chromium input", "Google Chrome input", "Brave input",
  "Microsoft Edge input", "Vivaldi input", "ZOOM VoiceEngine",
  "Telegram Desktop", "telegram-desktop", "linphone", "Mumble",
  "WEBRTC VoiceEngine", "Skype", "Firefox Developer Edition",
  -- Custom: SoX rec (used by voice-dictation script)
  "SoX",
}
