#!/bin/bash
#########
# Neovim stable
#########
# NVIM=nvim-linux64
# NEOVIM_DOWNLOAD_URL=https://github.com/neovim/neovim/releases/download/stable/${NVIM}.tar.gz
# curl -fsSL "$NEOVIM_DOWNLOAD_URL" -o $NVIM.tar.gz
# tar -zxvf $NVIM.tar.gz > /dev/null
# [[ -d /usr/local/nvim ]] && rm -rf /usr/local/nvim
# mv -f nvim-linux64 /usr/local/nvim
# rm -rf $NVIM.tar.gz
# rm -rf $NVIM.tar
# ln -sf /usr/local/nvim/bin/nvim /usr/local/bin

#########
# Neovim nightly
#########
#curl -fLo /tmp/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
#tar -xzf /tmp/nvim-linux64.tar.gz -C /tmp
#mv /tmp/nvim-linux64/bin/nvim /usr/local/bin
#mv /tmp/nvim-linux64/lib/* /usr/local/lib/
#mv /tmp/nvim-linux64/share/nvim /usr/local/share
#rm -rf /tmp/nvim-linux64*
#########
# JQ
#########
JQ_VERSION="1.6"
JQ_DOWNLOAD_URL=https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64
curl -fsSL $JQ_DOWNLOAD_URL -o jq
chmod 755 jq
mv -f jq /usr/bin/jq


#########
# Gem
#########
gem install coderay

#########
# Language Servers
#########
npm i -g dockerfile-language-server-nodejs
npm i -g bash-language-server
npm i -g yaml-language-server
npm i -g vscode-json-languageservice

#########
# k9s
#########
#
# {{{ command line dashboard for kubernetes
curl -L -o /tmp/k9s.tar.gz \
 	https://github.com/derailed/k9s/releases/download/v0.21.7/k9s_Linux_x86_64.tar.gz
mkdir -p /tmp/k9s
tar xvf /tmp/k9s.tar.gz -C /tmp/k9s
mv /tmp/k9s/k9s /usr/local/bin
rm -rf /tmp/k9s
# }}}
