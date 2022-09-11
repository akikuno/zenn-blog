#!/bin/bash

# mkdir -p ~/.npm-global
# npm config set prefix '~/.npm-global'

# export PATH=~/.npm-global/bin:$PATH
# source ~/.profile

npm init --yes
npm install -g zenn-cli@latest

npx zenn init

# 🎉 Done!
# 早速コンテンツを作成しましょう

# 👇 新しい記事を作成する
# $ zenn new:article

# 👇 新しい本を作成する
# $ zenn new:book

# 👇 投稿をプレビューする
# $ zenn preview

npx zenn new:article
npx zenn preview
