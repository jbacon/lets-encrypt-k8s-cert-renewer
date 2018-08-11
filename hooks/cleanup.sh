#!/bin/sh
set -e
rm -f ./${CERTBOT_TOKEN}
kubectl create secret generic ${CERT_SECRET_NAME} \
--from-file=cert.pem=/root/cert.pem \
--from-file=privkey.pem=/root/privkey.pem \
--from-file=fullchain.pem=/root/fullchain.pem \
--from-file=chain.pem=/root/chain.pem \
--dry-run \
-o yaml \
| kubectl apply -f -
kubectl create secret tls ${TLS_SECRET_NAME} \
--cert=/root/fullchain.pem \
--key=/root/privkey.pem \
--dry-run \
-o yaml \
| kubectl apply -f -
sleep 30