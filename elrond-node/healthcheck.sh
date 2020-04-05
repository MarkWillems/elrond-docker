#!/bin/bash
CURRENT="$(/home/elrond/elrond-nodes/node-0/node -v)"
if [ -z "$GITHUBTOKEN" ]; then 
    LATEST="$(curl --silent "https://api.github.com/repos/ElrondNetwork/elrond-go/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
else      
    LATEST="$(curl --silent -H "Authorization: token $GITHUBTOKEN" "https://api.github.com/repos/ElrondNetwork/elrond-go/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
fi

if [[ $CURRENT =~ $LATEST ]]; then
  echo "[$(date +%x_%H:%M:%S)] container is running up to date with version $CURRENT"
  exit 0
else
  echo "[$(date +%x_%H:%M:%S)] container  is running $CURRENT and is not the latest $LATEST, execute restart"
  pkill node
  exit 1
fi

