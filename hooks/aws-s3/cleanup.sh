#!/bin/sh
set -e
aws s3 rm "s3://${AWS_S3_BUCKET_NAME}/.well-known/acme-challenge/${CERTBOT_TOKEN}"