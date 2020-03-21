FROM elrond:botn

USER root
RUN apt-get update -y && apt-get upgrade -y && apt install -y  apt-utils wget git docker.io curl
RUN cd /lib && wget https://github.com/wasmerio/wasmer/releases/download/0.12.0/libwasmer_runtime_c_api.so
ADD  --chown=elrond:elrond updater.sh /opt/updater.sh
RUN chmod +x /opt/updater.sh
CMD ["/opt/updater.sh"]
