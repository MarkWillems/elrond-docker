# Elrond Docker
This is a simple setup for Docker and staying as close as possible to using the official scripts.

* Run multiply nodes
* Rootless container
* Autoupdate (containers are updated with the official scripts)
* Every start the containers updates itself if required

There is a sidecar container with check for new version, its checks the node version of each container and restart the container if the Node version is outdated. This mechanisme is made because systemd is missing in a container. So its a bit curious but the containers are updating themselves at startup. It made to fit for Battle of the Nodes in mind and therefore supporting erasing databases etc.

# How to use

## Prerequisites
- Have Docker installed on your server: see <a href="https://docs.docker.com/install/" target="_blank">https://docs.docker.com/install/</a>

TL;DR for Ubuntu 18.04
```
apt install -y docker.io
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

## Configure your nodes

### For every node you want to run
This should be scripted later on but this are the steps for now

#### 1. Create node data directory
To persist the data, create a new subdirectory in de volumes map. The directory should match the name of your node.

```
cd /opt/elrond-docker
mkdir -p /opt/elrond-docker/volume/<node-name>/VALIDATOR_KEYS/
chown -R 1000:1000 volumes/
```

#### 1.1 Import existing key
It reuses the mechanisme of the official scripts, so it scans for an node-0.zip in the VALIDATOR_KEYS map. If you want to use your own keys than place the node-0.zip in the directory.

#### 2 Edit docker-compose.yml
You need to edit the docker-compose.yml for every node you want to add. 
Duplicate the <node-name> block and replace this with the name of the node and the desired api port, add this block to the file:
```
  <node-name>:
  image: elrond:botn
  container_name: nodename
  restart: unless-stopped
  ports:
   - <api_port>:8080
  volumes:
   - "./volumes/<node-name>/:/home/elrond/elrond-nodes/node-0/"
```   
For example if I want two run two nodes which are named example-1 and example-2 than this should be the compose file (besides creating two subdirectories as described in step 1): 
   
```
version: '3.2'
services:
 autoupdater:
  container_name: autoupdater
  build:
   context: ./elrond-updater/
   dockerfile: Dockerfile
  restart: always
  volumes:
   - /var/run/docker.sock:/var/run/docker.sock
   - "./volumes/:/volumes"
 example-1:
  image: elrond:botn
  container_name: nodename
  restart: unless-stopped
  ports:
   - 8080:8080
  volumes:
   - "./volumes/example-1/:/home/elrond/elrond-nodes/node-0/"
 example-2:
  image: elrond:botn
  container_name: nodename
  restart: unless-stopped
  ports:
   - 8080:8080
  volumes:
   - "./volumes/example-2/:/home/elrond/elrond-nodes/node-0/"
```
## Running

Start all the nodes with running the docker-compose.yml file.
```
docker-compose up -d
```
Alternatives:
- https://github.com/mrz1703/elrond-node
- https://github.com/ElrondNetwork/elrond-go-scripts-v2 (official scripts)
