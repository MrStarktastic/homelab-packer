#!/bin/bash

echo 'Starting cleanup...'

rm /etc/ssh/ssh_host_*
truncate -s 0 /etc/machine-id
apt-get autoremove -y --purge
apt-get clean -y
apt-get autoclean -y
cloud-init clean
echo 'datasource_list: [ NoCloud ]' > /etc/cloud/cloud.cfg.d/99-pve.cfg

sync
