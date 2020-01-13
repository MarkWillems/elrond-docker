#!/bin/bash
source /home/elrond/elrond-go-scripts-v2/config/functions.cfg

CUSTOM_HOME=/home/elrond
NUMBEROFNODES=1
WORKDIR="$CUSTOM_HOME/elrond-nodes/node-0"
mkdir -p $CUSTOM_HOME/elrond-nodes;
mkdir -p $CUSTOM_HOME/elrond-utils;
mkdir -p $CUSTOM_HOME/VALIDATOR_KEYS

echo $NUMBEROFNODES > /home/elrond/.numberofnodes

sed -i 's/ubuntu/elrond/g' /home/elrond/elrond-go-scripts-v2/config/variables.cfg
sed -n '/sudo systemctl/!p' -i /home/elrond/elrond-go-scripts-v2/config/functions.cfg
sed -n '/sudo systemctl/!p' -i /home/elrond/elrond-go-scripts-v2/script.sh

git_clone
build_keygen
build_node
install
install_utils
keys

/home/elrond/elrond-go-scripts-v2/script.sh auto_upgrade
rm /home/elrond/elrond-nodes/node-0/ -rf
