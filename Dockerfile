FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
  && apt-get install -y build-essential x11vnc xvfb novnc \
  && apt-get -qq install -y pulseaudio pavucontrol \
  && apt-get install -y wget gnupg fonts-ipafont-gothic fonts-freefont-ttf

# install firefox
RUN apt-get install -y software-properties-common \
  && add-apt-repository ppa:mozillateam/ppa \
  && apt install -y firefox-esr

# install cloudflared
RUN wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb && dpkg -i cloudflared-linux-arm64.deb

COPY ./entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# novnc.pem
RUN openssl req -x509 -nodes -newkey rsa:3072 -keyout /usr/src/app/novnc.pem -out /usr/src/app/novnc.pem -days 3650 -subj "/C=PT/ST=Lisbon/L=Lisbon/O=N1ZES/OU=Discord/CN=toze.n1zes.tk" \
  && useradd -ms /bin/bash ubuntu \
  && chown ubuntu:ubuntu /usr/src/app/novnc.pem

USER ubuntu
WORKDIR /home/ubuntu

ENV DISPLAY=":1"

ENTRYPOINT "/usr/src/app/entrypoint.sh"

