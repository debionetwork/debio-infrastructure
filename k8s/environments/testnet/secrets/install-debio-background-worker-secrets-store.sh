#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=debio-network-testnet
REPOSITORY_OWNER=debionetwork
REPOSITORY_NAME=debio-background-worker
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
EOF
