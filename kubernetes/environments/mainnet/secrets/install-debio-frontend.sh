#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=debio-network
REPOSITORY_OWNER=debionetwork
REPOSITORY_NAME=debio-frontend
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
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/ETHEREUM_RPC_HTTP_URL/versions/latest
        path: ETHEREUM_RPC_HTTP_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/ETHEREUM_BLOCK_EXPLORER_URL/versions/latest
        path: ETHEREUM_BLOCK_EXPLORER_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/OCTOPUS_EXPLORER_URL/versions/latest
        path: OCTOPUS_EXPLORER_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/PINATA_GATEWAY_URL/versions/latest
        path: PINATA_GATEWAY_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/PINATA_JWT/versions/latest
        path: PINATA_JWT
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/PINATA_REQUIRED_DOCUMENT/versions/latest
        path: PINATA_REQUIRED_DOCUMENT
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/RECAPTCHA_SITE_KEY/versions/latest
        path: RECAPTCHA_SITE_KEY
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/RPC_WEBSOCKET_URL/versions/latest
        path: RPC_WEBSOCKET_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/USDT_NEAR_CONTRACT_ADDRESS/versions/latest
        path: USDT_NEAR_CONTRACT_ADDRESS
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_URL/versions/latest
        path: API_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_BASIC_AUTH_USERNAME/versions/latest
        path: API_BASIC_AUTH_USERNAME
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_BASIC_AUTH_PASSWORD/versions/latest
        path: API_BASIC_AUTH_PASSWORD
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_LAB_ROLE/versions/latest
        path: WEB_LAB_ROLE
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_LAB_SENTRY_DSN/versions/latest
        path: WEB_LAB_SENTRY_DSN
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_LAB_MIXPANEL_TOKEN/versions/latest
        path: WEB_LAB_MIXPANEL_TOKEN
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/ESCROW_ADDRESS/versions/latest
        path: ESCROW_ADDRESS
  secretObjects:
    - secretName: ${REPOSITORY_NAME}-secrets-store
      type: Opaque
      data: 
        - key: VUE_APP_RECAPTCHA_SITE_KEY
          objectName: RECAPTCHA_SITE_KEY
        - key: VUE_APP_ROLE
          objectName: WEB_LAB_ROLE
        - key: VUE_APP_DEBIO_SUBSTRATE_WS
          objectName: RPC_WEBSOCKET_URL
        - key: VUE_APP_WEB3_RPC
          objectName: ETHEREUM_RPC_HTTP_URL
        - key: VUE_APP_BACKEND_API
          objectName: API_URL
        - key: VUE_APP_DEBIO_API_KEY
          objectName: API_BASIC_AUTH_PASSWORD
        - key: VUE_APP_USERNAME
          objectName: API_BASIC_AUTH_USERNAME
        - key: VUE_APP_PASSWORD
          objectName: API_BASIC_AUTH_PASSWORD
        - key: VUE_APP_MIXPANEL_TOKEN
          objectName: WEB_LAB_MIXPANEL_TOKEN
        - key: VUE_APP_SENTRY_DSN
          objectName: WEB_LAB_SENTRY_DSN
        - key: VUE_APP_PINATA_GATEWAY
          objectName: PINATA_GATEWAY_URL
        - key: VUE_APP_PINATA_JWT_KEY
          objectName: PINATA_JWT
        - key: VUE_APP_PINATA_REQUIRED_DOCUMENT
          objectName: PINATA_REQUIRED_DOCUMENT
        - key: VUE_APP_ETHERSCAN
          objectName: ETHEREUM_BLOCK_EXPLORER_URL
        - key: VUE_APP_OCTOPUS_EXPLORER
          objectName: OCTOPUS_EXPLORER_URL
        - key: VUE_APP_DEBIO_USDT_TOKEN_ID
          objectName: USDT_NEAR_CONTRACT_ADDRESS
        - key: VUE_APP_DEBIO_ESSCROW_ADDRESS
          objectName: ESCROW_ADDRESS
EOF
