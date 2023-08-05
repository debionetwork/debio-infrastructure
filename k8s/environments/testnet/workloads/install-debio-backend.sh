#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=debio-network-testnet
REPOSITORY_OWNER=debionetwork
REPOSITORY_NAME=debio-backend
REPOSITORY_FULL_NAME=${REPOSITORY_OWNER}/${REPOSITORY_NAME}
DOCKER_TAG=0ceac74e9b87fafcf1b52c6a889dd6bae4fd6f9d

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
  --set containerPort=3000 \
  --set service.port=3000 \
  --set-string resources.requests.cpu=100m \
  --set-string resources.requests.memory=512Mi \
  --set-string resources.limits.cpu=300m \
  --set-string resources.limits.memory=1024Mi \
  --set replicaCount=1 \
  --set autoscaling.enabled=true \
  --set autoscaling.minReplicas=1 \
  --set autoscaling.maxReplicas=5 \
  --set-string nodeSelector.node_pool=general \
  --set-string nodeSelector."iam\.gke\.io/gke-metadata-server-enabled"="true" \
  --debug
kubectl rollout status deployment/${REPOSITORY_NAME}
