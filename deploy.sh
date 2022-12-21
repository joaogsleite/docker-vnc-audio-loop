#!/bin/bash

source .env

ssh -p $SSH_PORT $SSH_SERVER "
  mkdir -p $SSH_FOLDER
  cd $SSH_FOLDER
"

FILES_TO_SEND=".env Dockerfile cloudflared docker-compose.yml entrypoint.sh mozilla"
tar czf - $FILES_TO_SEND | ssh -p $SSH_PORT $SSH_SERVER "cd $SSH_FOLDER && tar xvzf -"
ssh -p $SSH_PORT $SSH_SERVER "cd $SSH_FOLDER && docker-compose down && docker-compose up -d --build"

