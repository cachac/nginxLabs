#!/bin/bash
mkdir /opt/nginx-exporter
cd /opt/nginx-exporter

sudo useradd --system --no-create-home --shell /bin/false nginx-exporter

curl -L https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.11.0/nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz -o nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz

tar -zxf nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz

rm nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz

chown -R nginx-exporter:nginx-exporter /opt/nginx-exporter
cat <<EOT > /etc/systemd/system/nginx-exporter.service
[Unit]
Description=Nginx Exporter
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=0

[Service]
User=nginx-exporter
Group=nginx-exporter
Type=simple
Restart=on-failure
RestartSec=5s

ExecStart=/opt/nginx-exporter/nginx-prometheus-exporter \
    -nginx.scrape-uri=http://localhost:8080/status

[Install]
WantedBy=multi-user.target
EOT

systemctl enable nginx-exporter
systemctl start nginx-exporter


