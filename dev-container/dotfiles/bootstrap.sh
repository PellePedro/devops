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

echo $DOTFILES_HOME

echo "=== START of Configuration ==="

mkdir -p $HOME/.vifm/colors
mkdir -p $HOME/.config

config_files=(
${HOME}/.zshrc
${HOME}/.tmux.conf
${HOME}/.p10k.zsh
${HOME}/.vifm/vifmrc
${HOME}/.vifm/colors/nord.vifm
)
for file in "${config_files[@]}"; do
    [[ -f $file ]] || [[ -L $file ]] && rm -f $file && echo "removing $file"
done

config_directories=(
${HOME}/.zsh
${HOME}/.antigen
${HOME}/.tmux
)
for directory in "${config_directories[@]}"; do
    [[ -d $directory ]] && rm -rf $directory && echo "removing $directory"
done

# Bootstrap zsh
mkdir -p $HOME/.zsh
cp $DOTFILES_HOME/zsh/zshrc $HOME/.zshrc
cp $DOTFILES_HOME/zsh/p10k.zsh $HOME/.p10k.zsh
curl -fLo $HOME/.zsh/antigen.zsh --create-dirs https://git.io/antigen

# Bootstrap vifm
cp $DOTFILES_HOME/vifm/vifmrc $HOME/.vifm/vifmrc
cp $DOTFILES_HOME/vifm/colors/nord.vifm $HOME/.vifm/colors/nord.vifm

#  pip3 packages
pip3 install --user --upgrade pynvim
pip3 install --user --upgrade pytest
pip3 install --user --upgrade yq

#  nvim configuration
nvimHome=${HOME}/.config/nvim
[[ -d $nvimHome ]] && rm -rf $nvimHome
git clone  https://github.com/pellepedro/nvim.git $nvimHome

#  tmux configuration
[[ ! -d "${HOME}/.tmux" ]] && rm -rf $HOME/.tmux
git clone --recurse https://github.com/pellepedro/tmux.git $HOME/.tmux
cp ${HOME}/.tmux/.tmux.conf $HOME

mkdir -p $HOME/go/{src,bin}
export GOBIN=${HOME}/bin
if [[ "$(uname)" == "Linux" ]]; then
  export PATH=${PATH}:/usr/local/go/bin
fi

mkdir -p $HOME/.cache/nvim/


touch $HOME/.z
zsh -c "source $HOME/.zshrc"

echo "=== END of Configuration ==="

mkdir -p $HOME/go/{src,bin} $HOME/bin
export GOBIN=${HOME}/bin
if [[ "$(uname)" == "Linux" ]]; then
  export PATH=${PATH}:/usr/local/go/bin
fi

go install github.com/go-delve/delve/cmd/dlv@latest
go get github.com/jesseduffield/lazygit

