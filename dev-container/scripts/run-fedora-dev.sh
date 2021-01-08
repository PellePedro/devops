#/bin/bash

CONTAINER=docker.pkg.github.com/pellepedro/devops/fedora-dev:latest
docker run -it --rm --privileged --name fedora \
    -v ${HOME}/.config/jesseduffield/lazygit:/home/devops/.config/lazygit:z \
    -v ${HOME}/.gitconfig:/home/devops/.gitconfig:z \
    -v ${HOME}/.netrc:/home/devops/.netrc:z \
    -v ${HOME}/.ssh:/home/devops/.ssh:z \
    -v ${HOME}/.gitconfig:/home/devops/.gitconfig:z \
    -v ${HOME}:/home/devops/host:rw \
    -v ${HOME}/go/pkg/mod:/home/devops/go/pkg/mod:z \
    ${CONTAINER}
