#!/bin/bash

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
apt-get update
apt-get upgrade -y
NEEDRESTART_MODE=a apt-get dist-upgrade -y
