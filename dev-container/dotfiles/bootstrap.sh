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
)
for directory in "${config_directories[@]}"; do
    [[ -d $directory ]] && rm -rf $directory && echo "removing $directory"
done


# Bootstrap zsh
mkdir -p $HOME/.zsh
ln -sf $DOTFILES_HOME/zsh/zshrc $HOME/.zshrc
cp $DOTFILES_HOME/zsh/p10k.zsh $HOME/.p10k.zsh
curl -fLo $HOME/.zsh/antigen.zsh --create-dirs https://git.io/antigen

# Bootstrap vifm
ln -sf $DOTFILES_HOME/vifm/vifmrc $HOME/.vifm/vifmrc
ln -sf $DOTFILES_HOME/vifm/colors/nord.vifm $HOME/.vifm/colors/nord.vifm

#  pip3 packages
pip3 install --user --upgrade pynvim
pip3 install --user --upgrade yq

if [[ ! -d "${HOME}/.config/nvim" ]]; then
    git clone https://github.com/pellepedro/nvim.git $HOME/.config/nvim
    nvim --headless -c PlugInstall -c UpdateRemotePlugins -c qa!
    #nvim --headless -c InstallCoc -c qa!
    nvim --headless -c "CocInstall  coc-rls"              -c qa!
    nvim --headless -c "CocInstall  coc-go"               -c qa!
    nvim --headless -c "CocInstall  coc-yaml"             -c qa!
    nvim --headless -c "CocInstall  coc-json"             -c qa!
    nvim --headless -c "CocInstall  coc-highlight"        -c qa!
    nvim --headless -c "CocInstall  coc-python"           -c qa!
    nvim --headless -c "CocInstall  coc-diagnostic"       -c qa!
    nvim --headless -c "CocInstall  coc-java"             -c qa!
    nvim --headless -c "CocInstall  coc-java-debug"       -c qa!
    nvim --headless -c "CocInstall  coc-snippets"         -c qa!
fi

mkdir -p $HOME/go/{src,bin}
export GOBIN=${HOME}/bin
if [[ "$(uname)" == "Linux" ]]; then
  export PATH=${PATH}:/usr/local/go/bin
fi

# lazygit
go get github.com/jesseduffield/lazygit
go get -u github.com/kisielk/errcheck
go get -u github.com/zmb3/gogetdoc
go get -u golang.org/x/tools/cmd/goimports
go get -u golang.org/x/lint/golint
go get -u golang.org/x/tools/gopls
go get -u github.com/alecthomas/gometalinter
go get -u github.com/fatih/gomodifytags
go get -u github.com/fatih/motion
go get -u github.com/koron/iferr

touch $HOME/.z
zsh -c "source $HOME/.zshrc"

echo "=== END of Configuration ==="
