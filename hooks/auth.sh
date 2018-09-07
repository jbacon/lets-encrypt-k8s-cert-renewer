#!/bin/sh
set -e
echo ${CERTBOT_VALIDATION} > ./${CERTBOT_TOKEN}
apk add --no-cache curl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
./kubectl create secret generic ${ACME_SECRET_NAME} \
--from-file=${CERTBOT_TOKEN}=${PWD}/${CERTBOT_TOKEN} \
--dry-run \
-o yaml \
| ./kubectl apply -f -
sleep 30