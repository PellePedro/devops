#/bin/bash

CONTAINER=docker.io/pellepedro/nvim:latest
PROJ=$( cat ~/projects | fzf )
docker run -it --rm --privileged --name dev \
    -e TMUX=1 \
    -v ${HOME}/.ssh:/home/devops/.ssh:z \
    -v ${PROJ}:/home/devops/host:rw \
    -v ${HOME}/go/pkg/mod:/home/devops/go/pkg/mod:z \
    -w /home/devops/host \
    ${CONTAINER}
