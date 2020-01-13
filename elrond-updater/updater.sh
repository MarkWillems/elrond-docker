#!/bin/bash

set -e
echo "Run autoupdater!"

function while_check {
    while true; do
            echo "test"
            docker ps
for dir in /volumes/*/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    echo ${dir##*/}    # print everything after the final "/"
done

     #docker restart  $(docker ps -aq --filter name=elrond-*)
     ls /volumes/nodename/node  -all
     
     sleep 10s <&0 & wait
    done
}

while_check
