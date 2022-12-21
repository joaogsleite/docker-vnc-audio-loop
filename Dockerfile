FROM ubuntu:22.04

# install x11vnc, novnc, pulseaudio and firefox
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
  && apt-get install -y build-essential x11vnc xvfb novnc \
  && apt-get -qq install -y pulseaudio pavucontrol \
  && apt-get install -y wget gnupg fonts-ipafont-gothic fonts-freefont-ttf software-properties-common \
  && add-apt-repository ppa:mozillateam/ppa \
  && apt install -y firefox-esr

# install cloudflared
RUN ARCH=$(dpkg --print-architecture) \
  && wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$ARCH.deb \
  && dpkg -i cloudflared-linux-$ARCH.deb \
  && rm cloudflared-linux-$ARCH.deb

# configure novnc
RUN openssl req -x509 -nodes -newkey rsa:3072 -keyout /usr/src/app/novnc.pem -out /usr/src/app/novnc.pem -days 3650 -subj "/C=PT/ST=Lisbon/L=Lisbon/O=Organization/OU=Department/CN=localhost" \
  && useradd -ms /bin/bash ubuntu \
  && chown ubuntu:ubuntu /usr/src/app/novnc.pem \
  && echo '<iframe style="width:100%;height:100%;border:none;" src="vnc.html"></iframe>' > /usr/share/novnc/index.html

# user, virtual display and entrypoint
COPY ./entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh
USER ubuntu
WORKDIR /home/ubuntu
ENV DISPLAY=":1"
ENTRYPOINT "/usr/src/app/entrypoint.sh"

