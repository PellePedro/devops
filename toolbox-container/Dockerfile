FROM alpine:latest

RUN apk add --update --no-cache \
    netcat-openbsd \
    bind-tools \
    curl \
    bash \
    darkhttpd \
    tcpdump \
    iperf3 \
    openssh



RUN printf '\nTools:\n\
 - bash \n\
 - curl \n\
 - darkhttpd \n\
 - dig \n\
 - iperf3 \n\
 - nslookup \n\
 - ping \n\
 - ssh \n\
 - tcpdump \n\
 - traceroute \n\
 - wget \n\
 \n\
Example: \n\
 - nc -z -v -w 2 dns-name port \n\
 - nslookup www.bing.com \n\
 - traceroute www.bing.com \n\
 - darkhttpd <path> \n\
 - tcpdump -i eth0 -w packet.pcap \n\
 - iperf3 -s \n\
 - iperf3 -c <serverip> \n\
 - wget http://192.168.1.1/1.tar.gz \n\
 - curl -o 1.tar.gz http://192.168.1.1/1.tar.gz \n\
 - dig www.bing.com\n' >> /root/info.txt

