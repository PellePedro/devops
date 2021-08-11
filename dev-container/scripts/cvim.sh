#!/bin/bash

if [ -z "$1" ]; then 
  PROJ=$( cat ~/projects | fzf )
elif [ "$1" = "." ]; then
  PROJ=$(pwd)
else
  PROJ=$1
fi

echo "Mounting directory ${PROJ}"

CONTAINER=docker.io/pellepedro/lvim:latest
docker run -it --rm --privileged \
    -v $(readlink -f /var/run/docker.sock):/var/run/docker.sock \
    -v ${HOME}/.ssh:/home/devops/.ssh:z \
    -v ${PROJ}:/home/devops/host:rw \
    -v ${HOME}/go/pkg/mod:/home/devops/go/pkg/mod:z \
    -w /home/devops/host \
    ${CONTAINER}
