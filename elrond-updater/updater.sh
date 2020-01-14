#!/bin/bash

set -e
echo "$(date +%x_%H:%M:%S) start the update provess"

function while_check {
    while true; do
        echo "[$(date +%x_%H:%M:%S)] starting an update round"

        for dir in /volumes/*/ ; do
            echo "[$(date +%x_%H:%M:%S)] check to see  if container $(basename $dir) is running"
            if [  "$(docker ps -q -f name=$(basename dir))" ]; then
                continue
            fi
            echo "[$(date +%x_%H:%M:%S)] container $(basename $dir) found"

            if [ ! -f /volumes/$(basename $dir)/node ]; then
                echo "[$(date +%x_%H:%M:%S)] /volumes/$(basename $dir)/node not found"
                continue
            fi

            CURRENT="$(/volumes/$(basename $dir)/node -v)"
            if [ -z "$GITHUBTOKEN" ]; then 
                LATEST="$(curl --silent "https://api.github.com/repos/ElrondNetwork/elrond-go/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
            else      
                LATEST="$(curl --silent -H "Authorization: token $GITHUBTOKEN" "https://api.github.com/repos/ElrondNetwork/elrond-go/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
            fi
            if [[ $CURRENT =~ $LATEST ]]; then
                echo "[$(date +%x_%H:%M:%S)] container $(basename $dir) is running up to date with version $CURRENT"
            else
                echo "[$(date +%x_%H:%M:%S)] container $(basename $dir) is running $CURRENT and is not the latest $LATEST, execute restart"
                docker restart $(basename $dir)
            fi
        done
        echo "[$(date +%x_%H:%M:%S)] update round done"
        sleep 480s <&0 & wait
    done
}

while_check
