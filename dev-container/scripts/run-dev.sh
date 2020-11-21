#/bin/bash

PUBLIC_FEDORA_CONTAINER=docker.io/pellepedro/devenv:latest

printf "\033[32m\xE2\x9c\x93 Running Development Container ${FEDORA_DEV} \033[0m\n"
sudo podman run -it --privileged \
    -v ${HOME}/.netrc:/home/devops/.netrc:z \
    -v ${HOME}/.ssh:/home/devops/.ssh:z \
    -v ${HOME}:/home/devops/host:rw \
    -v ${HOME}/go/pkg/mod:/home/devops/go/pkg/mod:z \
    ${PUBLIC_FEDORA_CONTAINER} -name fdev
