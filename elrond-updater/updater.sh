#!/bin/bash

set -e
echo "Run autoupdater!"

function while_check {
    while true; do
            echo "test"
    docker ps
    docker restart  $(docker ps -aq --filter name=elrond-*)
     sleep 10s <&0 & wait
    done
}

while_check
