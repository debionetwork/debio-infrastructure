#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=debio-network
REPOSITORY_OWNER=debionetwork
REPOSITORY_NAME=debio-customer-ui
REPOSITORY_FULL_NAME=${REPOSITORY_OWNER}/${REPOSITORY_NAME}
DOCKER_TAG=2.4.0

echo "Installing ${REPOSITORY_NAME}"
helm repo add debionetwork https://charts.debio.network
helm repo update
helm upgrade ${REPOSITORY_NAME} debionetwork/debio-app-deployer \
  --install \
  --set-string nameOverride=${REPOSITORY_NAME} \
  --set-string image.repository=${REPOSITORY_FULL_NAME} \
  --set-string image.tag=${DOCKER_TAG} \
  --set-string serviceAccount.name=${REPOSITORY_NAME} \
  --set-string serviceAccount.annotations."iam\.gke\.io/gcp-service-account"=${REPOSITORY_NAME}@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
  --set config.secretsStore.enabled=true \
  --set-string config.secretsStore.providerClass=${REPOSITORY_NAME}-secrets-store-provider \
  --set-string config.secretsStore.name=${REPOSITORY_NAME}-secrets-store \
  --set containerPort=80 \
  --set service.port=80 \
  --set-string nodeSelector.node_pool=general \
  --set-string nodeSelector."iam\.gke\.io/gke-metadata-server-enabled"="true" \
  --debug
kubectl rollout status deployment/${REPOSITORY_NAME}
