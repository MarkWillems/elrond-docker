FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && apt-get upgrade -y && apt install -y curl  apt-utils wget git docker.io
RUN cd /lib && wget https://github.com/wasmerio/wasmer/releases/download/0.12.0/libwasmer_runtime_c_api.so
ADD updater.sh /opt/updater.sh
RUN chmod +x /opt/updater.sh
CMD ["/opt/updater.sh"]
root@vultr:/opt/elrond-docker# cat elrond-updater/updater.sh
#!/bin/bash

set -e
echo "$(date +%x_%H:%M:%S) start the update provess"

function while_check {
    while true; do
        echo "$(date +%x_%H:%M:%S) starting an update round"

        for dir in /volumes/*/ ; do
            echo "[$(date +%x_%H:%M:%S)] check to see  if container $(basename $dir) is running"
            if [ ! "$(docker ps -q -f name=$(basename dir))" ]; then
                echo "[$(date +%x_%H:%M:%S)] container $(basename $dir) found"
                if [  -f /volumes/$(basename $dir)/node ]; then
                    CURRENT="$(/volumes/$(basename $dir)/node -v)"
                    LATEST=$(curl --silent "https://api.github.com/repos/ElrondNetwork/elrond-go/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
                    if [[ $CURRENT =~ $LATEST ]]; then
                        echo "[$(date +%x_%H:%M:%S)] container $(basename $dir) is running up to date with version $CURRENT"
                    else
                        echo "[$(date +%x_%H:%M:%S)] container $(basename $dir) is running $CURRENT and is not the latest $LATEST, execute restart"
                        docker restart $(basename $dir)
                    fi
                else
                         echo "$(date +%x_%H:%M:%S) /volumes/$(basename $dir)/node not found"
                fi
            fi
        done
        echo "[$(date +%x_%H:%M:%S)] update round done"
        sleep 480s <&0 & wait
    done
}

while_check
