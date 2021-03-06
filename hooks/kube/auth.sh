#!/bin/sh
set -e
apk add --no-cache curl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
./kubectl patch secret ${KUBE_ACME_SECRET_NAME} \
--type json \
--patch "
[
    {
        \"op\": \"replace\",
        \"path\": \"/data\",
        \"value\": {
            \"${CERTBOT_TOKEN}\": \"$(echo -n "${CERTBOT_VALIDATION}" | base64 | tr -d \\n)\"
        }
    }
]"
sleep 30