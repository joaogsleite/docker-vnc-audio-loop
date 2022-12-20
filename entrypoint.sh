#!/usr/bin/env bash

# create virtual display
pkill Xvfb
Xvfb :1 -ac &
sleep 10

# start vnc server
x11vnc -create -forever -display :1 &

# pulse audio output to mic loop
pulseaudio -D --exit-idle-time=-1
pactl load-module module-null-sink sink_name=SpeakerOutput sink_properties=device.description="Dummy_Output"
pacmd load-module module-virtual-source source_name=VirtualMicrophone

# novnc: vnc web interface
websockify -D --web=/usr/share/novnc/ --cert=/usr/src/app/novnc.pem 6080 localhost:5900
echo '<iframe style="width:100%;height:100%;border:none;" src="vnc.html"></iframe>' > /usr/share/novnc/index.html

# cloudflare tunnel
TUNNEL_ID=$(cd /home/ubuntu/.cloudflared/ && ls *.json | sed -e 's/\.json$//')
cloudflared tunnel route dns $TUNNEL_ID $NOVNC_DOMAIN
cloudflared tunnel run $TUNNEL_ID &

# start firefox
DISPLAY=:1 firefox-esr

