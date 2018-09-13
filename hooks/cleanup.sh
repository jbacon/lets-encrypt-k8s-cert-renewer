#!/bin/sh
set -e
rm -f ./${CERTBOT_TOKEN}
apk add --no-cache curl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
./kubectl patch secret ${CERT_SECRET_NAME} \
--type json \
--patch "
[
    {
        \"op\": \"replace\",
        \"path\": \"/data\",
        \"value\": {
            \"cert.pem\": \"$(cat /root/cert.pem | base64 | tr -d \\n)\",
            \"privkey.pem\": \"$(cat /root/privkey.pem | base64 | tr -d \\n)\",
            \"fullchain.pem\": \"$(cat /root/fullchain.pem | base64 | tr -d \\n)\",
            \"chain.pem\": \"$(cat /root/chain.pem | base64 | tr -d \\n)\"
        }
    }
]"
./kubectl patch secret ${TLS_SECRET_NAME} \
--type json \
--patch "
[
    {
        \"op\": \"replace\",
        \"path\": \"/data\",
        \"value\": {
            \"tls.crt\": \"$(cat /root/fullchain.pem | base64 | tr -d \\n)\",
            \"tls.key\": \"$(cat /root/privkey.pem | base64 | tr -d \\n)\"
        }
    }
]"