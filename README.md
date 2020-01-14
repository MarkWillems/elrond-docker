# Elrond Docker
This is a simple setup for Docker and staying as close as possible to using the official scripts.

* Run multiply nodes
* Rootless container
* Autoupdate (containers are updated with the official scripts)
* Every start the containers updates itself if required

There is a sidecar container with check for new version, its checks the node version of each container and restart the container if the Node version is outdated. This mechanisme is due to systemd missing and the container is tagged with botn. So its a bit curious but the containers are updating themselves at startup.

# How to use

## Prerequisites
- Have Docker installed on your server: see <a href="https://docs.docker.com/install/" target="_blank">https://docs.docker.com/install/</a>

TL;DR for Ubuntu 18.04
```
systemctl start docker
systemctl enable docker
curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

## Installation
Execute the commands below. Maybye wrap it in a script later on. This will install the nodes in /opt/elrond-docker.
```
cd /opt 
sudo git clone https://github.com/MarkWillems/elrond-docker.git
cd elrond-docker/
sudo mkdir -p volumes && chown -R 1000:1000 volumes/
docker build /opt/elrond-docker/elrond-node/ -t elrond:botn
docker-compose build
```
The data of all the nodes will be in the volumes directory.

## Configure nodes
For every node you want to run
```
cd /opt/elrond-docker
mkdir -p volumes/<node-name>
chown -R 1000:1000 volumes/
```
### Import existing key
It reuses the mechanisme of the official scripts, so it scans for an node-0.zip in de VALIDATOR_KEYS map.
```
mkdir -p /opt/elrond-docker/volume/<node-name>/VALIDATOR_KEYS/
```
Place the node-0.zip in this directory.

Alternatives:
- https://github.com/mrz1703/elrond-node
- https://github.com/ElrondNetwork/elrond-go-scripts-v2 (official scripts)
