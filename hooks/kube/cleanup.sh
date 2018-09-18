#!/bin/sh
set -e
./kubectl patch secret ${KUBE_ACME_SECRET_NAME} \
--type json \
--patch "
[
    {
        \"op\": \"replace\",
        \"path\": \"/data\",
        \"value\": {
            \"placeholder\": \"$(echo -n placeholder | base64 | tr -d \\n)\"
        }
    }
]"