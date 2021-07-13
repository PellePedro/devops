#/bin/bash

CONTAINER=docker.io/pellepedro/nvim:latest
PROJ=$( cat ~/projects | fzf )
docker run -it --rm --privileged \
    -v $(readlink -f /var/run/docker.sock):/var/run/docker.sock \
    -v ${HOME}/.ssh:/home/devops/.ssh:z \
    -v ${PROJ}:/home/devops/host:rw \
    -v ${HOME}/go/pkg/mod:/home/devops/go/pkg/mod:z \
    -w /home/devops/host \
    ${CONTAINER}
