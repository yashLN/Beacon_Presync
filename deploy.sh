#!/bin/bash
read -p "Enter Your fee recipient/Ethereum/Metamask address: " code
[[ "$code" =~ ^0x[0-9a-fA-F]{40}$ ]] && echo "" || { echo "You have entered an invalid address"; exit $ERRCODE; }
sudo echo "recipientcode=$code" > /var/.recipientcode.txt
#sudo sed -i  -e "s/recipientcode/$code/g" /var/docker-compose.yaml
jwtDir="JWT"
jwtFile="jwt.hex"
if [ $# -eq 0 ]; then
      read -p "Enter Your JWT token: " token
      echo $token > "$jwtFile"
fi
while test $# != 0
do
    case "$1" in
    -j|--jwt)
      if [ -d "$jwtDir" ]; then sudo rm -Rf $jwtDir/; fi
      echo "generating hex file"
      openssl rand -hex 32 | tr -d "\n" > "$jwtFile"
      ;;
    *) 
      read -p "Enter Your JWT token: " token                               
      echo $token > "$jwtFile"
      ;;
    esac
    shift
done

mkdir -p $jwtDir
sudo mv jwt.hex $jwtDir/
sudo systemctl restart beacon-geth
