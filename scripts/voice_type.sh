#!/bin/bash

# Configuration
PID_FILE="/tmp/voice_type.pid"
AUDIO_FILE="/tmp/voice_type.wav"
ENV_FILE="$HOME/code/openbook/translation_automation/.env"

# Extract API Key safely
API_KEY=$(grep "ELEVENLABS_API_KEY" "$ENV_FILE" | cut -d '"' -f2)

if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    # Currently recording: Stop it
    kill -INT $(cat "$PID_FILE")
    rm -f "$PID_FILE"

    # Immediately signal Waybar to update UI to idle
    pkill -RTMIN+8 waybar

    notify-send -t 2000 "🎙️ Transcribing..." "Sending audio to ElevenLabs..."
    
    RESPONSE=$(curl -s -X POST "https://api.elevenlabs.io/v1/speech-to-text" \
        -H "xi-api-key: $API_KEY" \
        -F "file=@$AUDIO_FILE" \
        -F "model_id=scribe_v1")
        
    TEXT=$(echo "$RESPONSE" | jq -r '.text // empty')
    
    if [ -n "$TEXT" ]; then
        echo -n "$TEXT" | wl-copy
        notify-send -t 3000 "📋 Transcribed & Copied" "$TEXT"
    else
        notify-send -u critical "❌ Transcription failed" "$RESPONSE"
    fi
else
    # Not recording: Start
    rm -f "$AUDIO_FILE"
    
    # Start recording
    pw-record "$AUDIO_FILE" &
    echo $! > "$PID_FILE"
    
    # Signal Waybar to update UI to recording
    pkill -RTMIN+8 waybar
    
    notify-send -t 1500 "🔴 Recording..." "Click the mic icon again to stop & transcribe"
fi
