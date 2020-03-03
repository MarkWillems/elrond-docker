FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get upgrade -y 
RUN apt install -y git sudo apt-utils curl wget gcc systemd nano unzip
# Add the elrond user so the nodes dont run as root
RUN useradd -ms /bin/bash elrond
# sudo password is not required for the elrond user because of the update scripts
RUN bash -c 'echo "elrond ALL=(ALL:ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)'

ENV GO_VERSION=1.13.8
# set correct architecture -> "uname -m" (x86_64 -> amd64, aarch64 -> arm64)
ENV ARCH="amd64"
RUN wget https://dl.google.com/go/go${GO_VERSION}.linux-${ARCH}.tar.gz \
    && tar -xvf go${GO_VERSION}.linux-${ARCH}.tar.gz \
    && mv go /usr/local \
    && rm go${GO_VERSION}.linux-${ARCH}.tar.gz \
    && apt-get clean

ENV GOROOT=/usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

USER elrond
WORKDIR /home/elrond
ENV GOPATH=/home/elrond/go 
RUN mkdir -p $GOPATH/src/github.com/ElrondNetwork
RUN git clone https://github.com/ElrondNetwork/elrond-go-scripts-v2
ADD  --chown=elrond:elrond install_elrond.sh /tmp/install_elrond.sh
RUN chmod +x /tmp/install_elrond.sh && /tmp/install_elrond.sh
ADD  --chown=elrond:elrond entrypoint.sh /home/elrond/entrypoint.sh
RUN chmod +x /home/elrond/entrypoint.sh
RUN mkdir -p  /home/elrond/elrond-nodes/node-0/ && chown 1000:1000 -R /home/elrond/elrond-nodes/node-0/ 
CMD ["/home/elrond/entrypoint.sh"]
