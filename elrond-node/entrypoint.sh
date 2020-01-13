#!/bin/bash
source /home/elrond/elrond-go-scripts-v2/config/functions.cfg

NODE_NAME="piet-1"
# This works for the official scripts
NODE_HOME=/home/elrond/elrond-nodes/node-0
CUSTOM_HOME=/home/elrond
WORKDIR=$NODE_HOME
GOPATH=$CUSTOM_HOME/go
if ! [ -d "$NODE_HOME/db" ]; then

  echo "reisntall"
  install
  build_keygen
  keys
fi 

sed -i "s/NodeDisplayName = \"\"/NodeDisplayName = \"${NODE_NAME//\//\\/}\"/" $NODE_HOME/config/prefs.toml

CURRENT=$($NODE_HOME/node -v)
#See current available version
LATEST=$(curl --silent "https://api.github.com/repos/ElrondNetwork/elrond-go/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
if [[ $CURRENT =~ $LATEST ]]; then
    echo "Node version $CURRENT it up to date."
else
    echo "Node version $CURRENT is not the latest $LATEST, start updating"
    /home/elrond/elrond-go-scripts-v2/script.sh auto_upgrade
fi
cd $NODE_HOME && ./node -use-log-view -rest-api-interface localhost:8080
