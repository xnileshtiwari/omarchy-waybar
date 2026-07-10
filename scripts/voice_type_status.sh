#!/bin/bash
PID_FILE="/tmp/voice_type.pid"

if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo '{"text": "<span color=\"#ff3333\"></span>", "tooltip": "Recording... Click to stop and transcribe", "class": "recording"}'
else
    echo '{"text": "", "tooltip": "Voice Typing: Click to record", "class": "idle"}'
fi
