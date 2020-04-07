FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt install -y git sudo apt-utils curl wget zip gcc systemd nano unzip
# Add the elrond user so the nodes dont run as root
RUN useradd -ms /bin/bash elrond
# sudo password is not required for the elrond user because of the update scripts
RUN bash -c 'echo "elrond ALL=(ALL:ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)'
RUN sudo ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so
RUN cd /lib && wget https://github.com/wasmerio/wasmer/releases/download/0.12.0/libwasmer_runtime_c_api.so

ENV GO_VERSION=1.13.5
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
ADD  --chown=elrond:elrond healthcheck.sh /home/elrond/healthcheck.sh
RUN chmod +x /home/elrond/healthcheck.sh
HEALTHCHECK --interval=5m --retries=2 --timeout=30s --start-period=10m CMD /home/elrond/healthcheck.sh || exit 1
ADD  --chown=elrond:elrond entrypoint.sh /home/elrond/entrypoint.sh
RUN chmod +x /home/elrond/entrypoint.sh
RUN mkdir -p  /home/elrond/elrond-nodes/node-0/config && chown 1000:1000 -R /home/elrond/elrond-nodes/node-0/config/ 
CMD ["/home/elrond/entrypoint.sh"]

