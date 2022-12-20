#!/bin/bash
set -e
color ()
{
  echo -en "\033[31m"  ## red
  eval $* | while read line; do
      echo -en "\033[36m"  ## blue
      echo $line
      echo -en "\033[31m"  ## red
  done
  echo -en "\033[0m"
}
exec 3>&1
log ()
{
    color echo "INFO: $1" 1>&3
}
log "Download Dockercompose and Beacon services"

wget https://raw.githubusercontent.com/yashLN/Beacon_Presync/main/docker-compose-grpc.yaml
wget https://raw.githubusercontent.com/yashLN/Beacon_Presync/main/beacon-geth.service 

log "Downloaded!!"
log "Stopping the current beacon-geth service"
sudo systemctl stop beacon-geth.service
[ -e /var/tmp/docker-compose.yaml ] && sudo rm /var/tmp/docker-compose.yaml
log "Stopped beacon-geth Service"

log "Apply the new beacon-geth Service"

sudo cp docker-compose-grpc.yaml /var/docker-compose.yaml
sudo cp beacon-geth.service  /etc/systemd/system/beacon-geth.service

sudo systemctl daemon-reload
echo "#######################################################################################"
sleep 2

log "Starting the new service"
sudo systemctl start beacon-geth.service

log "Cleaning Up Everything"
sudo rm -rf docker-compose-grpc.yaml beacon-geth.service
