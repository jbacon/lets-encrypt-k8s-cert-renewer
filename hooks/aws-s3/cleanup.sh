#!/bin/sh
set -e
aws s3 rm "s3://${AWS_BUCKET_NAME}/.well-known/acme-challenge/${CERTBOT_TOKEN}"