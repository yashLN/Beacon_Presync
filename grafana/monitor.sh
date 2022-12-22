#! /bin/bash 
set -e 

prometheusYmlPath=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/prometheus.yml
prometheusServicePath=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/prometheus.service
prometheus_datasource=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/prometheus_datasource.yaml
dashboard=https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/dashboard.yaml
small_amount_validators=https://docs.prylabs.network/assets/grafana-dashboards/small_amount_validators.json

echo "###### Downloading Prometheus Tar File ######"
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.41.0-rc.0/prometheus-2.41.0-rc.0.linux-amd64.tar.gz
tar -xvf prometheus-2.41.0-rc.0.linux-amd64.tar.gz
cd prometheus-2.41.0-rc.0.linux-amd64

sudo cp -n -r  prometheus promtool /usr/local/bin/
sudo cp -n -r consoles/ console_libraries/ /etc/prometheus/
cd 
curl -o prometheus.yml $prometheusYmlPath
sudo cp -n prometheus.yml /etc/prometheus/prometheus.yml

sudo groupadd --system prometheus || true 
sudo useradd -s /sbin/nologin --system -g prometheus prometheus || true 
sudo chown -R prometheus:prometheus /etc/prometheus/ /var/lib/prometheus/
sudo chmod -R 775 /etc/prometheus/ /var/lib/prometheus/

prometheus --version

echo "Installed Prometheus Successfully"
echo "Adding Prometheus Service"
curl -o prometheus.service $prometheusServicePath 
sudo cp -n prometheus.service /etc/systemd/system/prometheus.service
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus
wget https://dl.grafana.com/enterprise/release/grafana-enterprise-9.3.2-1.x86_64.rpm
sudo yum install grafana-enterprise-9.3.2-1.x86_64.rpm -y 

wget $prometheus_datasource
ls 
sudo cp -n prometheus_datasource.yaml /etc/grafana/provisioning/dashboards/datasources/prometheus_datasource.yaml

wget $small_amount_validators
sudo cp -n small_amount_validators.json /etc/grafana/provisioning/dashboards/small_amount_validators.json
wget $dashboard 
sudo cp -n dashboard.yaml /etc/grafana/provisioning/dashboards/dashboard.yaml
sudo systemctl restart grafana-server
