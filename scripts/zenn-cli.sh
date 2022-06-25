#!/bin/bash

mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

export PATH=~/.npm-global/bin:$PATH
source ~/.profile

npm init --yes
npm install -g zenn-cli

sudo npx zenn init

npx zenn preview
