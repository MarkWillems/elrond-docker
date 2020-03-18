#!/bin/bash
source /home/elrond/elrond-go-scripts-v2/config/functions.cfg

CUSTOM_HOME=/home/elrond
NUMBEROFNODES=1
WORKDIR="$CUSTOM_HOME/elrond-nodes/node-0"
mkdir -p $CUSTOM_HOME/elrond-nodes;
mkdir -p $CUSTOM_HOME/elrond-utils;
mkdir -p $CUSTOM_HOME/VALIDATOR_KEYS
GITHUBTOKEN=""

if [ -z "$GITHUBTOKEN" ]; then
                  BINARYVER="tags/$(curl --silent "https://api.github.com/repos/ElrondNetwork/elrond-go/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
                  CONFIGVER="tags/$(curl --silent "https://api.github.com/repos/ElrondNetwork/elrond-config/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"

            else
             BINARYVER="tags/$(curl --silent -H "Authorization: token $GITHUBTOKEN" "https://api.github.com/repos/ElrondNetwork/elrond-go/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
             CONFIGVER="tags/$(curl --silent -H "Authorization: token $GITHUBTOKEN" "https://api.github.com/repos/ElrondNetwork/elrond-config/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
    fi
echo $NUMBEROFNODES > /home/elrond/.numberofnodes
sed -i 's/ubuntu/elrond/g' /home/elrond/elrond-go-scripts-v2/config/variables.cfg
sed -n '/sudo systemctl/!p' -i /home/elrond/elrond-go-scripts-v2/config/functions.cfg
sed -n '/sudo systemctl/!p' -i /home/elrond/elrond-go-scripts-v2/script.sh
paths
go_lang
git_clone
build_keygen
build_node
install
install_utils
keys

/home/elrond/elrond-go-scripts-v2/script.sh auto_upgrade
rm /home/elrond/elrond-nodes/node-0/ -rf
cp /home/elrond/elrond-utils/termui /home/elrond -f
