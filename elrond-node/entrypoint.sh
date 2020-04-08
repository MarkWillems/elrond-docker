#!/bin/bash
source /home/elrond/elrond-go-scripts-v2/config/functions.cfg

# This works for the official scripts
NODE_HOME=/home/elrond/elrond-nodes/node-0
CUSTOM_HOME=/home/elrond
WORKDIR=$NODE_HOME
GOPATH=$CUSTOM_HOME/go
NODE_KEYS_LOCATION="$NODE_HOME/VALIDATOR_KEYS"
INDEX=0
sed -i 's/^GITHUBTOKEN=""/GITHUBTOKEN="$GITHUBTOKEN"/g' /home/elrond/elrond-go-scripts-v2/config/variables.cfg

mkdir -p $NODE_KEYS_LOCATION
PEM_FILE=/home/elrond/elrond-nodes/node-0/config/initialBalancesSk.pem

if [ -z "$INITIAL_BALANCES_SK_0" ]; then
    echo "[$(date +%x_%H:%M:%S)] No environment pam set"
else
   echo "[$(date +%x_%H:%M:%S)] Found environment keys"
   echo "[$(date +%x_%H:%M:%S)] getting $KEY_INDEX key index"
   INITIAL_BALANCES_SK="INITIAL_BALANCES_SK_$KEY_INDEX"
   INITIAL_NODES_SK="INITIAL_NODES_SK_$KEY_INDEX"
   
   echo "${!INITIAL_BALANCES_SK}" > /home/elrond/elrond-nodes/node-0/config/initialBalancesSk.pem
   echo "${!INITIAL_NODES_SK}" > /home/elrond/elrond-nodes/node-0/config/initialNodesSk.pem
   cd /home/elrond/elrond-nodes/node-0/config && zip node-0.zip *.pem && cp node-0.zip /home/elrond/elrond-nodes/node-0/VALIDATOR_KEYS/ -f
fi

if ! [ -d "$NODE_HOME/db" ]; then
  echo "[$(date +%x_%H:%M:%S)] Initial run for $NODE_NAME"
  install
  build_keygen
  yes | keys
fi

sed -i "s/NodeDisplayName = \"\"/NodeDisplayName = \"${NODE_NAME//\//\\/}\"/" $NODE_HOME/config/prefs.toml

CURRENT=$($NODE_HOME/node -v)
#See current available version
if [ -z "$GITHUBTOKEN" ]; then 
    LATEST="$(curl --silent "https://api.github.com/repos/ElrondNetwork/elrond-go/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
else      
    LATEST="$(curl --silent -H "Authorization: token $GITHUBTOKEN" "https://api.github.com/repos/ElrondNetwork/elrond-go/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
fi
if [[ $CURRENT =~ $LATEST ]]; then
    echo "[$(date +%x_%H:%M:%S)] Node $NODE_NAME is up to date with version $CURRENT."
else
    echo "[$(date +%x_%H:%M:%S)] Node $NODE_NAME with version $CURRENT is not the latest $LATEST, start auto upgrade"
    /home/elrond/elrond-go-scripts-v2/script.sh upgrade
    /home/elrond/elrond-go-scripts-v2/script.sh auto_upgrade
fi
# make sure node got enough permission to read the keys
chmod 700 $NODE_HOME/config/initialNodesSk.pem
chmod 700 $NODE_HOME/config/initialBalancesSk.pem
cd $NODE_HOME && ./node -use-log-view -rest-api-interface :8080
