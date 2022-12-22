#! /bin/bash 
set -e 

prometheusYmlPath=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/prometheus.yml
prometheusServicePath=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/prometheus.service
prometheus_datasource=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/prometheus_datasource.yml
dashboard=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/dashboard.yml
small_amount_validators=https://docs.prylabs.network/assets/grafana-dashboards/small_amount_validators.json

echo "###### Downloading Prometheus Tar File ######"
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.41.0-rc.0/prometheus-2.41.0-rc.0.linux-amd64.tar.gz
tar -xvf prometheus-2.41.0-rc.0.linux-amd64.tar.gz
cd prometheus-2.41.0-rc.0.linux-amd64

sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles/ console_libraries/ /etc/prometheus/
cd 
curl -o prometheus.yml $prometheusYmlPath
sudo mv prometheus.yml /etc/prometheus/prometheus.yml

sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/ /var/lib/prometheus/
sudo chmod -R 775 /etc/prometheus/ /var/lib/prometheus/

prometheus --version

echo "Installed Prometheus Successfully"
echo "Adding Prometheus Service"
curl -o prometheus.service $prometheusServicePath 
sudo mv prometheus.service /etc/systemd/system/prometheus.service
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus
wget https://dl.grafana.com/enterprise/release/grafana-enterprise-9.3.2-1.x86_64.rpm
sudo yum install grafana-enterprise-9.3.2-1.x86_64.rpm

wget $prometheus_datasource
sudo mv prometheus_datasource.yml /etc/grafana/provisioning/dashboards/datasources/prometheus_datasource.yml

wget $small_amount_validators
sudo mv small_amount_validators.json /etc/grafana/provisioning/dashboards/small_amount_validators.json
wget $dashboard 
sudo mv dashboard.yml /etc/grafana/provisioning/dashboards/dashboard.yml
sudo systemctl restart grafana-server
