#!/bin/bash
set -xi

apt-install() {
	apt-get install --no-install-recommends -y "$@"
}

VERSION_ID=$(awk -F= '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')

apt-install docker.io

. /etc/os-release
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${ID^}_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${ID^}_${VERSION_ID}/Release.key -O Release.key
sudo apt-key add - < Release.key
sudo apt-get update -qq
sudo apt-get -qq -y install buildah

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

K9S_VERSION=v0.24.14
curl -Lo - https://github.com/derailed/k9s/releases/download/"${K9S_VERSION}"/k9s_Linux_x86_64.tar.gz \
  | tar -xz -C /usr/bin/  && \
  chmod +x /usr/bin/k9s


# cache is useless to keep
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
