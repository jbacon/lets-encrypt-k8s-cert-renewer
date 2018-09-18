#!/bin/sh
set -e
pip install awscli
echo -n ${CERTBOT_VALIDATION} >> ${PWD}/${CERTBOT_TOKEN}
aws s3 cp "${PWD}/${CERTBOT_TOKEN}" "s3://${AWS_S3_BUCKET_NAME}/.well-known/acme-challenge/${CERTBOT_TOKEN}"
sleep 30