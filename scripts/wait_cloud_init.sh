#!/bin/bash

echo 'Waiting for cloud-init to finish...'

cloud-init status --wait
STATUS=$(cloud-init status --format=json | jq -r .status)
if [ "$STATUS" != "done" ]; then
    echo "Cloud-init $STATUS:"
    cat /var/log/cloud-init.log
    exit 1
fi

echo 'Cloud-init finished successfully.'
