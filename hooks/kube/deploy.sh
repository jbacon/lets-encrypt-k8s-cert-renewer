#!/bin/sh
set -e
./kubectl patch secret ${CERT_SECRET_NAME} \
--type json \
--patch "
[
    {
        \"op\": \"replace\",
        \"path\": \"/data\",
        \"value\": {
            \"cert.pem\": \"$(cat ${RENEWED_LINEAGE}/cert.pem | base64 | tr -d \\n)\",
            \"privkey.pem\": \"$(cat ${RENEWED_LINEAGE}/privkey.pem | base64 | tr -d \\n)\",
            \"fullchain.pem\": \"$(cat ${RENEWED_LINEAGE}/fullchain.pem | base64 | tr -d \\n)\",
            \"chain.pem\": \"$(cat ${RENEWED_LINEAGE}/chain.pem| base64 | tr -d \\n)\"
        }
    }
]"
./kubectl patch secret ${KUBE_TLS_SECRET_NAME} \
--type json \
--patch "
[
    {
        \"op\": \"replace\",
        \"path\": \"/data\",
        \"value\": {
            \"tls.crt\": \"$(cat ${RENEWED_LINEAGE}/fullchain.pem | base64 | tr -d \\n)\",
            \"tls.key\": \"$(cat ${RENEWED_LINEAGE}/privkey.pem | base64 | tr -d \\n)\"
        }
    }
]"