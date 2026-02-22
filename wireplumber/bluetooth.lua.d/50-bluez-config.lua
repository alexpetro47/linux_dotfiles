bluez_monitor.enabled = true

bluez_monitor.properties = {
  -- A2DP = high-quality stereo playback (48kHz), HFP = bidirectional with mic (16kHz mono).
  -- hfp_hf enables auto-switch: A2DP for music/playback, HFP when mic is requested
  -- (Teams, voice-dictation, etc.) — switches back to A2DP when mic released.
  ["bluez5.roles"] = "[ a2dp_sink a2dp_source hfp_hf ]",

  -- Only offer codecs AirPods actually support (no AAC on Ubuntu default PipeWire)
  ["bluez5.codecs"] = "[ sbc sbc_xq ]",

  ["bluez5.hfphsp-backend"] = "native",
  ["bluez5.enable-sbc-xq"] = true,
  ["bluez5.enable-msbc"] = true,
  ["bluez5.enable-hw-volume"] = true,

  ["with-logind"] = true,
}

bluez_monitor.rules = {
  {
    matches = {
      {
        { "device.name", "matches", "bluez_card.*" },
      },
    },
    apply_properties = {
      -- Auto-connect A2DP + HFP on reconnect
      ["bluez5.auto-connect"] = "[ a2dp_sink a2dp_source hfp_hf ]",
      -- Hardware volume control
      ["bluez5.hw-volume"] = "[ a2dp_sink a2dp_source hfp_hf ]",
      -- Default to A2DP high-quality profile
      ["device.profile"] = "a2dp-sink",
    },
  },
  {
    matches = {
      {
        { "node.name", "matches", "bluez_input.*" },
      },
      {
        { "node.name", "matches", "bluez_output.*" },
      },
    },
    apply_properties = {
      -- Don't suspend bluetooth audio (prevents reconnection dropouts)
      ["session.suspend-timeout-seconds"] = 0,
    },
  },
}
