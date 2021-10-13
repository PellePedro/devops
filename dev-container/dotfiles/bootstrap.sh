#!/usr/bin/env bash

set -e

##
# OS X has no `realpath` by default, so emulate it
# @link https://stackoverflow.com/a/18443300
command -v realpath > /dev/null || realpath() {
    OURPWD=$PWD
    cd "$(dirname "$1")"
    LINK=$(readlink "$(basename "$1")")
    while [ "$LINK" ]; do
        cd "$(dirname "$LINK")"
        LINK=$(readlink "$(basename "$1")")
    done
    REALPATH="$PWD/$(basename "$1")"
    cd "$OURPWD"
    echo "$REALPATH"
}
DOTFILES_HOME="$(dirname "$(realpath $0)")"

echo "$DOTFILES_HOME"

sudo chown -R $USER:$USER $DOTFILES_HOME

echo "=== START of Configuration ==="

mkdir -p $HOME/.vifm/colors
mkdir -p $HOME/.config

config_files=(
"${HOME}"/.zshrc
"${HOME}"/.tmux.conf
"${HOME}"/.p10k.zsh
"${HOME}"/.vifm/vifmrc
"${HOME}"/.vifm/colors/nord.vifm
)
for file in "${config_files[@]}"; do
    [[ -f $file ]] || [[ -L $file ]] && rm -f $file && echo "removing $file"
done

config_directories=(
"${HOME}/.zsh"
"${HOME}/.antigen"
"${HOME}/.tmux"
"${HOME}/.config/nvim"
"${HOME}/.config/lvim"
"${HOME}/.tmux"
"${HOME}/.cache"
"$HOME/.local/share/nvim/site/pack/packer"
"$HOME/.local/share/lunarvim"
)
for directory in "${config_directories[@]}"; do
    [[ -d "$directory" ]] && rm -rf $directory && echo "removing $directory"
done

# Bootstrap zsh
mkdir -p "$HOME"/.zsh
cp $DOTFILES_HOME/zsh/zshrc $HOME/.zshrc
cp $DOTFILES_HOME/zsh/p10k.zsh $HOME/.p10k.zsh
curl -fLo $HOME/.zsh/antigen.zsh --create-dirs https://git.io/antigen

# Bootstrap vifm
cp $DOTFILES_HOME/vifm/vifmrc $HOME/.vifm/vifmrc
cp $DOTFILES_HOME/vifm/colors/nord.vifm $HOME/.vifm/colors/nord.vifm

#  pip3 packages
pip install --user --upgrade pynvim
pip install --user --upgrade pytest
pip install --user --upgrade yq
pip install --user --upgrade ansible-core
pip install --user --upgrade ansible

#  Lunarvim configuration
lvimHome=${HOME}/.config/lvim

git clone --depth 1 https://github.com/pellepedro/lvim.git "$lvimHome"

git clone https://github.com/wbthomason/packer.nvim ~/.local/share/lunarvim/site/pack/packer/start/packer.nvim

mkdir -p ~/.local/share/lunarvim
LVBRANCH=rolling

git clone --branch "$LVBRANCH" https://github.com/pellepedro/lunarvim.git ~/.local/share/lunarvim/lvim
sudo cp "$HOME/.local/share/lunarvim/lvim/utils/bin/lvim" "/usr/local/bin"
cat <<EOT > "${HOME}/.local/bin/lvim"
#!/bin/sh

export LUNARVIM_CONFIG_DIR=\${HOME}/.config/lvim
export LUNARVIM_RUNTIME_DIR=\${HOME}/.local/share/lunarvim
exec nvim -u "\${HOME}/.local/share/lunarvim/lvim/init.lua" "\$@"
EOT

sudo chmod a+rx "${HOME}/.local/bin/lvim"

#  tmux configuration
[[ ! -d "${HOME}/.tmux" ]] && rm -rf "$HOME"/.tmux
git clone --recurse https://github.com/pellepedro/tmux.git "$HOME/.tmux"
cp "${HOME}/.tmux/.tmux.conf" "$HOME"

mkdir -p "$HOME"/go/{src,bin}
export GOBIN=${HOME}/bin
if [[ "$(uname)" == "Linux" ]]; then
  export PATH=${PATH}:/usr/local/go/bin
fi

mkdir -p "$HOME"/.cache/nvim/


touch $HOME/.z
zsh -c "source $HOME/.zshrc"

echo "=== END of Configuration ==="

mkdir -p $HOME/go/{src,bin} $HOME/bin
export GOBIN=${HOME}/bin
if [[ "$(uname)" == "Linux" ]]; then
  export PATH=${PATH}:/usr/local/go/bin
fi

go install golang.org/x/tools/cmd/goimports@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/jesseduffield/lazydocker@latest
