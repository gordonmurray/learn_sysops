#!/usr/bin/env bash

set -xe

sudo su -

export RELEASE="2.2.1"

wget https://github.com/prometheus/prometheus/releases/download/v${RELEASE}/prometheus-${RELEASE}.linux-amd64.tar.gz

tar xvf prometheus-${RELEASE}.linux-amd64.tar.gz

cd prometheus-${RELEASE}.linux-amd64/

# Create Prometheus system group
groupadd --system prometheus
grep prometheus /etc/group

# Create Prometheus system user
useradd -s /sbin/nologin -r -g prometheus prometheus

#Create configuration and data directories for Prometheus
rm -rf /etc/prometheus
mkdir -p /etc/prometheus
mkdir -p /etc/prometheus/rules
mkdir -p /etc/prometheus/rules.d
mkdir -p /etc/prometheus/files_sd
mkdir -p /var/lib/prometheus

# Copy Prometheus binary files to a directory in your $PATH
cp prometheus promtool /usr/local/bin/
ls /usr/local/bin/

# Copy consoles and console_libraries to configuration files directory:
cp -r consoles/ console_libraries/ /etc/prometheus/

# Change directory permissions to Prometheus user and group
chown -R prometheus:prometheus /etc/prometheus/  /var/lib/prometheus/
chmod -R 775 /etc/prometheus/ /var/lib/prometheus/

# Start and enable Prometheus service
systemctl start prometheus
systemctl enable prometheus

systemctl status prometheus