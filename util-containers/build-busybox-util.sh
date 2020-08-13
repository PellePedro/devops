#!/bin/bash
# podman run --name python-dev -dt --userns keep-id -v $PROJECT_PATH:/home/data/:Z localhost/util:latest
set -ex

IMAGE=alpine-util

buildah delete -a
buildah from --name ${IMAGE} alpine:latest

cat <<EOF | buildah run ${IMAGE} -- sh
	apk add --update --no-cache netcat-openbsd bind-tools curl bash
	apk add --no-cache darkhttpd tcpdump iperf3 openssh
EOF



buildah run ${IMAGE} -- sh -c "$(cat <<E_LOG_EXEC
cat <<EOF > /root/info.txt
Tools:
 - bash
 - curl
 - darkhttpd
 - dig
 - iperf3
 - nslookup
 - ping
 - ssh
 - tcpdump
 - traceroute
 - wget

Example:
 - nc -z -v -w 2 dns-name port
 - nslookup www.bing.com
 - traceroute www.bing.com
 - darkhttpd <path>
 - tcpdump -i eth0 -w packet.pcap
 - iperf3 -s
 - iperf3 -c <serverip>
 - wget http://192.168.1.1/1.tar.gz
 - curl -o 1.tar.gz http://192.168.1.1/1.tar.gz
 - dig www.bing.com
EOF
E_LOG_EXEC
)"

buildah config --cmd "" --entrypoint '["/bin/ash"]' $IMAGE

buildah commit --squash --rm $IMAGE $IMAGE

################################################################################
# End
################################################################################
