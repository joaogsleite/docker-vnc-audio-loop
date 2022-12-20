#!/usr/bin/env bash

pkill Xvfb
Xvfb :1 -ac &
sleep 10
x11vnc -create -forever -display :1 &

# Load pulse audio
pulseaudio -D --exit-idle-time=-1
# Create a virtual speaker output
pactl load-module module-null-sink sink_name=SpeakerOutput sink_properties=device.description="Dummy_Output"
# Create a virtual microphone
pacmd load-module module-virtual-source source_name=VirtualMicrophone

websockify -D --web=/usr/share/novnc/ --cert=/usr/src/app/novnc.pem 6080 localhost:5900

TUNNEL_ID=$(cd /home/ubuntu/.cloudflared/ && ls *.json | sed -e 's/\.json$//')
cloudflared tunnel route dns $TUNNEL_ID $NOVNC_DOMAIN
cloudflared tunnel run $TUNNEL_ID &

DISPLAY=:1 firefox-esr

