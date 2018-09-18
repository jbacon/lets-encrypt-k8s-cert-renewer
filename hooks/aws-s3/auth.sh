#!/bin/sh
set -e
apk add --no-cache curl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
pip install awscli
echo -n ${CERTBOT_VALIDATION} >> ${PWD}/${CERTBOT_TOKEN}
aws s3 cp "${PWD}/${CERTBOT_TOKEN}" "s3://${AWS_BUCKET_NAME}/.well-known/acme-challenge/${CERTBOT_TOKEN}"
sleep 30