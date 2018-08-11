#!/bin/sh
set -e
echo ${CERTBOT_VALIDATION} > ./${CERTBOT_TOKEN}
kubectl create secret generic ${ACME_SECRET_NAME} \
--from-file=${CERTBOT_TOKEN}=${PWD}/${CERTBOT_TOKEN} \
--dry-run \
-o yaml \
| kubectl apply -f -
sleep 30