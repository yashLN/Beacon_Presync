#!/bin/bash

echo "Download Dockercompose and Validator services"

wget https://raw.githubusercontent.com/yashLN/Beacon_Presync/main/validator/docker-compose.yaml
wget https://raw.githubusercontent.com/yashLN/Beacon_Presync/main/validator/validator.service

echo "Apply the new service"

sudo mkdir -p /var/validator 
sudo mv docker-compose.yaml /var/docker-compose.yaml
sudo mv validator.service  /etc/systemd/system/
sudo systemctl daemon-reload

echo "Starting the new service "  
sudo systemctl restart validator.service
