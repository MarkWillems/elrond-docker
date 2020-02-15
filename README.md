# Elrond Docker
This is a simple setup for Docker and staying as close as possible to using the official scripts.

* Run multiply nodes
* Rootless container
* Autoupdate (containers are updated with the official scripts)
* Every start the containers updates itself if required

There is a sidecar container which checks the latest release, that version is validated against each container running Node version and the sidecar restarts the container if his Node version is outdated. This mechanisme is made because systemd is missing in a container. So its a bit curious but the containers are updating themselves at startup. It is made to fit for Battle of the Nodes in mind, therefore supporting erasing databases etc which is controlled by the official Elrond scripts.

Alternatives:
- https://github.com/mrz1703/elrond-node
- https://github.com/ElrondNetwork/elrond-go-scripts-v2 (official scripts)

# How to use

## Prerequisites
- Have Docker and Docker Compose installed on your server: see <a href="https://docs.docker.com/install/" target="_blank">https://docs.docker.com/install/</a>

TL;DR for Ubuntu 18.04
```
apt install -y docker.io
systemctl start docker
systemctl enable docker
curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```


## Installation
Execute the commands below. This will install the nodes in /opt/elrond-docker, if desired change the location.
```
cd /opt
sudo git clone https://github.com/MarkWillems/elrond-docker.git
cd elrond-docker
```

The data of all the nodes will be stored in the volumes subdirectory.

## 1. Configure your nodes
Run the command below to initialise your node the first time.

``
./script.sh setup
``

First enter the number of nodes you want to and their names, second add the github token if you got this.

### 1.1 Import existing key
It reuses the mechanisme of the official scripts, so it scans for an node-0.zip in the VALIDATOR_KEYS map. If you want to use your own keys than place the node-0.zip in the ./volume/node-name/VALIDATOR_KEYS directory, This directory is created in step 1. The two keys (initialBalancesSk.pem and initialNodesSk.pem) should be placed in this zip file named 'node-0.zip'

## 2.Running

Start all the nodes
```
./script.sh start
```

## Other commands

### Stopping of all nodes

Stop all the nodes
```
./script.sh stop
```

### How to open termui of Elrond to get some stats of your node

```
docker exec -it <node-name> ./termui

```
### How to see the logging of a node?

```
 docker logs <node-name> --follow
```

### How to restart a node?
```
 docker restart <node-name>
```

### (re)set the github token
```
./script.sh github
```

### Rebuild the container images
```
./script.sh rebuild
```
