#!/bin/bash
source /home/elrond/elrond-go-scripts-mainnet/config/functions.cfg

# This works for the official scripts
NODE_HOME=/home/elrond/elrond-nodes/node-0
CUSTOM_HOME=/home/elrond
WORKDIR=$NODE_HOME
GOPATH=$CUSTOM_HOME/go
NODE_KEYS_LOCATION="$NODE_HOME/VALIDATOR_KEYS"
INDEX=0
sed -i 's/^GITHUBTOKEN=""/GITHUBTOKEN="$GITHUBTOKEN"/g' /home/elrond/elrond-go-scripts-mainnet/config/variables.cfg

mkdir -p $NODE_KEYS_LOCATION


if ! [ -d "$NODE_HOME/db" ]; then
  yes | keys
fi

sed -i "s/NodeDisplayName = \"\"/NodeDisplayName = \"${NODE_NAME//\//\\/}\"/" $NODE_HOME/config/prefs.toml


# make sure node got enough permission to read the keys
chmod 700 $NODE_HOME/config/validatorKey.pem
cd $NODE_HOME && ./node -use-log-view -rest-api-interface :8080
