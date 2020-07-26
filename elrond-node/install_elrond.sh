#!/bin/bash
source /home/elrond/elrond-go-scripts-mainnet/config/functions.cfg

CUSTOM_HOME=/home/elrond
NUMBEROFNODES=1
WORKDIR="$CUSTOM_HOME/elrond-nodes/node-0"
mkdir -p $CUSTOM_HOME/elrond-nodes;
mkdir -p $CUSTOM_HOME/elrond-utils;
mkdir -p $CUSTOM_HOME/VALIDATOR_KEYS
CONFIGVER="tags/$(curl --silent "https://api.github.com/repos/ElrondNetwork/elrond-config-mainnet/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
SHOWVER="1.0.146"
RELEASENOTES=$(curl --silent  "https://api.github.com/repos/ElrondNetwork/elrond-config-mainnet/releases/latest" | grep '"body": '| cut -f2- -d:)

echo $NUMBEROFNODES > /home/elrond/.numberofnodes
sed -i 's/ubuntu/elrond/g' /home/elrond/elrond-go-scripts-mainnet/config/variables.cfg
sed -n '/sudo systemctl/!p' -i /home/elrond/elrond-go-scripts-mainnet/config/functions.cfg
sed -n '/sudo systemctl/!p' -i /home/elrond/elrond-go-scripts-mainnet/script.sh
echo "showver $SHOWVER"

paths
go_lang
git_clone
build_keygen
build_node
install
install_utils
keys


rm /home/elrond/elrond-nodes/node-0/ -rf
cp /home/elrond/elrond-utils/termui /home/elrond -f
