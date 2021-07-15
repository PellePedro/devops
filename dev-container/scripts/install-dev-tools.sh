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
# k9s
#########
# https://github.com/derailed/k9s/releases/download/v0.24.14/k9s_Linux_x86_64.tar.gz

export K9S_VERSION=v0.24.14
curl -Lo - https://github.com/derailed/k9s/releases/download/"${K9S_VERSION}"/k9s_Linux_x86_64.tar.gz \
  | tar -xz -C /usr/bin/  && \
  chmod +x /usr/bin/k9s



