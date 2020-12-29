#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update  -y
apt-get install --no-install-recommends -y \
gperf \
luajit \
luarocks \
libuv1-dev \
libluajit-5.1-dev \
libunibilium-dev \
libmsgpack-dev \
libtermkey-dev \
libvterm-dev \
libutf8proc-dev \
ninja-build \
gettext \
libtool \
libtool-bin \
autoconf \
automake \
cmake \
make \
g++ \
pkg-config \
unzip \
git \
apt-transport-https \
ca-certificates
luarocks build mpack
luarocks build lpeg
luarocks build inspect
update-ca-certificates
