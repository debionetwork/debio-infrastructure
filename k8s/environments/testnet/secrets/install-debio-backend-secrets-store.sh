#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=debio-network-testnet
REPOSITORY_OWNER=debionetwork
REPOSITORY_NAME=debio-backend
REPOSITORY_FULL_NAME=${REPOSITORY_OWNER}/${REPOSITORY_NAME}

echo "Installing ${REPOSITORY_NAME}-secrets-store-provider"
cat <<EOF | kubectl apply -f -
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: ${REPOSITORY_NAME}-secrets-store-provider
spec:
  provider: gcp
  parameters:
    secrets: |
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/SECRET_MANAGER_PARENT/versions/latest
        path: SECRET_MANAGER_PARENT
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/POSTGRES_HOST/versions/latest
        path: POSTGRES_HOST
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/POSTGRES_DB/versions/latest
        path: POSTGRES_DB
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/POSTGRES_DB_LOCATIONS/versions/latest
        path: POSTGRES_DB_LOCATIONS
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/ETHEREUM_RPC_HTTP_URL/versions/latest
        path: ETHEREUM_RPC_HTTP_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_DSN/versions/latest
        path: API_DSN
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_SWAGGER_ENABLE/versions/latest
        path: API_SWAGGER_ENABLE
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/COINMARKETCAP_HOST/versions/latest
        path: COINMARKETCAP_HOST
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/COINMARKETCAP_API_KEY/versions/latest
        path: COINMARKETCAP_API_KEY
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/SODAKI_HOST/versions/latest
        path: SODAKI_HOST
  secretObjects:
    - secretName: ${REPOSITORY_NAME}-secrets-store
      type: Opaque
      data: 
        - key: PARENT
          objectName: SECRET_MANAGER_PARENT
        - key: HOST_POSTGRES
          objectName: POSTGRES_HOST
        - key: DB_POSTGRES
          objectName: POSTGRES_DB
        - key: DB_LOCATIONS
          objectName: POSTGRES_DB_LOCATIONS
        - key: WEB3_RPC
          objectName: ETHEREUM_RPC_HTTP_URL
        - key: SENTRY_DSN
          objectName: API_DSN
        - key: SWAGGER_ENABLE
          objectName: API_SWAGGER_ENABLE
        - key: COINMARKETCAP_HOST
          objectName: COINMARKETCAP_HOST
        - key: API_KEY_COINMARKETCAP
          objectName: COINMARKETCAP_API_KEY
        - key: SODAKI_HOST
          objectName: SODAKI_HOST
EOF
