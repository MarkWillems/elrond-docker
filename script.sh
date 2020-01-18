#!/bin/bash
set -e

#Color to the people
RED='\x1B[0;31m'
CYAN='\x1B[0;36m'
GREEN='\x1B[0;32m'
NC='\x1B[0m'

function rebuild {
    docker build ./elrond-node/ -t elrond:botn
    docker-compose -f autoupdater.yml build
    echo -e "${GREEN} Done rebuilding containers${NC}"
}

function setGitHubToken {
  echo -e ""
  echo -e "Elrond checks the current release through the GitHub Api multiply time every hour"
  echo -e "This can be blocked pretty fast if you don't set a GitHub token"
  echo -e "See: https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line"
  read -p "Set your gitHub token: " GITHUB_TOKEN
  echo "GITHUB_TOKEN=$GITHUB_TOKEN" > .env
  echo -e "${GREEN} Token set!${NC}"
}

function create_node {
  echo -e
  echo -e "${GREEN} Time to choose a node name for node number $(($INDEX+1)) ${NC}"
  echo -e
  read -p "Choose a custom name (default elrond-validator-$INDEX): " NODE_NAME
  if [ "$NODE_NAME" = "" ]
  then
      NODE_NAME="elrond-validator-$INDEX"
  fi

  mkdir -p ./volumes/$NODE_NAME/VALIDATOR_KEYS/
  echo -e "${GREEN} Generated directory for node $NODE_NAME${NC}"
  echo -e ""
  echo -e "If you want to import keys for this node than place a zip file named node-0.zip with keys in this director:"
  echo -e "./volumes/$NODE_NAME/VALIDATOR_KEYS/"
  echo -e ""
}

case "$1" in
'github')
    setGitHubToken
;;
'rebuild')
    rebuild
;;
'setup')
    echo -e "${GREEN} Start of initialising $NUMBEROFNODES node(s)${NC}"

    echo -e ""
    read -p "How many nodes do you want to run ? : " NUMBEROFNODES
    re='^[0-9]+$'
    if ! [[ $NUMBEROFNODES =~ $re ]] && [ "$NUMBEROFNODES" -gt 0 ]
    then
        NUMBEROFNODES = 1
    fi

    for i in $(seq 1 $NUMBEROFNODES);
    do
        INDEX=$(( $i - 1 ))
        create_node
    done
    echo -e ""
    setGitHubToken
    echo -e ""
    echo -e "The first time to container need to be build, this can take a few minutes." 
    read -p "Press any key to start to building! " YEAHYEAH
    echo -e ""
    rebuild
    echo -e ""
    echo -e "${GREEN} Initialising done${NC}"
    echo -e "${CYAN} Remember that if you want to import your existing keys,  you should copy them to the /volumes/<node-name>/VALIDATOR_KEYS/ directory before the start of the nodes.${NC}"
    sudo chown -R 1000:1000 volumes/
;;
'stop')
    echo -e "Stop the nodes"
    echo -e "- Clearing existing docker templates"
    rm *.node.yml -f
    echo -e "${GREEN}- Clearing docker templates done!${NC}"
    node_number=0

    for dir in ./volumes/*/ ; do

        node_name="$(basename $dir)"
        echo -e "- Generating docker file for $node_name"

        port=$((8081+$node_number))
        sed 's/<node-name>/'"$node_name"'/g' node.yml.tmpl > $node_name.node.yml
        sed -i 's/<api_port>/'"127.0.0.1:$port"'/g' $node_name.node.yml
        node_number=$node_number+1
        echo -e "${GREEN}- Generating docker file for $node_name done!${NC}"
    done

    compose_args="-f autoupdater.yml "
    for dir in ./*.node.yml ; do
        compose_args="$compose_args -f $(basename $dir)"
    done
    echo -e ""
    echo -e "Start docker-compose with this command:"
    echo -e "docker-compose $compose_args stop"
    echo -e ""
    docker-compose $compose_args stop
    echo -e ""
    echo -e "${GREEN}Nodes stopped${NC}"
    echo -e ""
;;
'start')
    echo -e "Start the nodes"
    echo -e "- Clearing docker templates"
    rm *.node.yml -f
    echo -e "${GREEN}- Clearing docker templates done!${NC}"
    node_number=0

    for dir in ./volumes/*/ ; do

        node_name="$(basename $dir)"
        echo -e "- Generating docker file for $node_name"

        port=$((8081+$node_number))
        sed 's/<node-name>/'"$node_name"'/g' node.yml.tmpl > $node_name.node.yml
        sed -i 's/<api_port>/'"127.0.0.1:$port"'/g' $node_name.node.yml
        node_number=$node_number+1
        echo -e "${GREEN}- Generating docker file for $node_name done!${NC}"
    done

    compose_args="-f autoupdater.yml "
    for dir in ./*.node.yml ; do
        compose_args="$compose_args -f $(basename $dir)"
    done
    sudo chown -R 1000:1000 volumes
    echo -e ""
    echo -e "Start docker-compose with this command:"
    echo -e "docker-compose $compose_args up -d  --remove-orphans"
    echo -e ""
    docker-compose $compose_args up -d  --remove-orphans
    echo -e ""
    echo -e "${GREEN}Nodes started in the background${NC}"
    echo -e ""
;;
'remove-node')
    echo -e ""
    echo -e "To remove node, just delete the subdirectory in the ./volumes directory and run ./script start"
    echo -e ""
;;
*)
  echo "Usage: Missing parameter ! [setup|start|stop|github|rebuild|remove-node]"
  ;;
esac
