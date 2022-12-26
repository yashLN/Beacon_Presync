#! /bin/bash

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

log (){
    color echo "INFO: $1" 1>&3
}
echo_hash(){
    echo "#############################################################"
}

downloadfile(){
  file=$(curl --silent  -o $1 $2 )
  log "Downloading $1"
  $file
  log "Downloaded $1"
}
prometheusYmlPath=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/prometheus.yml
prometheusServicePath=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/prometheus.service
prometheus_datasource=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/prometheus_datasource.yaml
dashboard=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/dashboard.yaml
small_amount_validators=https://docs.prylabs.network/assets/grafana-dashboards/small_amount_validators.json
node_exporter=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/node_exporter.service
beacon_dashboard=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/beacon-dashboard.json

echo_hash
log "Downloading Prometheus Tar File"
echo_hash

log "creating prometheus directories"
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

log "Downloading prometheus-2.41.0-rc.0.linux-amd64.tar.gz"
wget https://github.com/prometheus/prometheus/releases/download/v2.41.0-rc.0/prometheus-2.41.0-rc.0.linux-amd64.tar.gz --no-verbose  -q
log "Decompressing prometheus-2.41.0-rc.0.linux-amd64.tar.gz"
tar -xzf prometheus-2.41.0-rc.0.linux-amd64.tar.gz
log "Decompressed"

log "Installing"
cd prometheus-2.41.0-rc.0.linux-amd64
sudo cp -n -r  prometheus promtool /usr/local/bin/
sudo cp -n -r consoles/ console_libraries/ /etc/prometheus/
cd 
downloadfile prometheus.yml $prometheusYmlPath
sudo cp -n prometheus.yml /etc/prometheus/prometheus.yml

log "adding prometheus group"
[ $(getent group prometheus) ] || sudo groupadd --system prometheus

log "adding prometheus user"
id -u prometheus &>/dev/null || sudo useradd -s /sbin/nologin --system -g prometheus prometheus

sudo chown -R prometheus:prometheus /etc/prometheus/ /var/lib/prometheus/
sudo chmod -R 775 /etc/prometheus/ /var/lib/prometheus/

version=$(prometheus --version)
log "Installed Prometheus Successfully"
log "Adding Prometheus Service"

downloadfile prometheus.service $prometheusServicePath 
sudo cp -n prometheus.service /etc/systemd/system/prometheus.service


echo_hash
log  "Installing Node Exporter"
echo_hash

wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz --no-verbose  -q
log "Decompressing node_exporter-1.5.0.linux-amd64.tar.gz"
tar -xzf node_exporter-1.5.0.linux-amd64.tar.gz
log "Decompressed"

log "adding user nodeusr"
id -u nodeusr &>/dev/null || sudo useradd -rs /bin/false nodeusr 

sudo cp -r -n node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/

log " Node Exporter Installed Successfully"
log "Configuring Node Exporter Service"
downloadfile node_exporter.service $node_exporter
sudo cp node_exporter.service /etc/systemd/system/node_exporter.service

log "Reloading Daemon"
sudo systemctl daemon-reload
log "Reloaded"

sudo systemctl enable node_exporter
sudo systemctl restart node_exporter
log "Node Exporter Service Configured"

sleep 2

sudo systemctl start prometheus.service
sudo systemctl enable prometheus
log  "Prometheus and Node Exporter Configured Successfully"

echo_hash
log  "Installing Grafana"
echo_hash


downloadfile grafana-enterprise-9.3.2-1.x86_64.rpm https://dl.grafana.com/enterprise/release/grafana-enterprise-9.3.2-1.x86_64.rpm 
sudo yum install grafana-enterprise-9.3.2-1.x86_64.rpm -y  -q || true 
log "Installed Grafana Successfully"
log "configuring Prometheus Datasource"
downloadfile prometheus_datasource.yaml $prometheus_datasource 
sudo cp -n prometheus_datasource.yaml /etc/grafana/provisioning/datasources/prometheus_datasource.yaml

log "Configured Prometheus DataSource Successfully"

# curl -o small_amount_validators.json $small_amount_validators
# sudo cp -n small_amount_validators.json /etc/grafana/provisioning/dashboards/small_amount_validators.json
log "Creating Beacon Node Dashboard"
downloadfile dashboard.yaml $dashboard
sudo cp  dashboard.yaml /etc/grafana/provisioning/dashboards/dashboard.yaml

downloadfile beacon_dashboard.json $beacon_dashboard
sudo cp beacon_dashboard.json /etc/grafana/provisioning/dashboards/beacon_dashboard.json
sudo systemctl restart grafana-server
log "Restarting Grafana Service"

log "Dashboard Created"
ip=$(curl --silent  ifconfig.me)
log "Check Grafana URL: http://$ip:3000"
