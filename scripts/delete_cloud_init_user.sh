#!/bin/bash

rm -f /etc/sudoers.d/90-cloud-init-users
/usr/sbin/userdel -r -f $CI_USER
