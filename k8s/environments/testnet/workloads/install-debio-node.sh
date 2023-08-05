#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=debio-network-testnet
REPOSITORY_OWNER=debionetwork
REPOSITORY_NAME=debio-node
REPOSITORY_FULL_NAME=${REPOSITORY_OWNER}/${REPOSITORY_NAME}
DOCKER_TAG=87ace72

echo "Installing ${REPOSITORY_NAME}"
helm repo add debionetwork https://charts.debio.network
helm repo update
helm upgrade ${REPOSITORY_NAME} debionetwork/debio-node \
  --install \
  --set-string nameOverride=${REPOSITORY_NAME} \
  --set-string image.repository=${REPOSITORY_FULL_NAME} \
  --set-string image.tag=${DOCKER_TAG} \
  --set-string config.chain=testnet \
  --set-string config.telemetryUrl="wss://telemetry.testnet.octopus.network/submit 9" \
  --set-string config.nodes[0].name=full1 \
  --set-string config.nodes[0].keys.private=a31867571c0781ad0199dd5c8828a8d047489d4259ad4e0d34fdc8b64589c96a \
  --set-string config.nodes[0].keys.public=12D3KooWNY7UJZXNLdKszCBqpBJnRef95HYq1LosME31VKBBV21K \
  --set config.nodes[0].validator=false \
  --set config.nodes[0].archive=false \
  --set config.nodes[0].bootnode=true \
  --set config.nodes[0].allowIngressP2P=false \
  --set config.nodes[0].allowIngressHttpRPC=false \
  --set config.nodes[0].allowIngressWsRPC=true \
  --set config.nodes[0].allowIngressPrometheus=false \
  --set config.nodes[0].telemetry=true \
  --set-string config.nodes[1].name=full2 \
  --set-string config.nodes[1].keys.private=8049be4f6f678961dbf8c358b291ccc4720328be9b6f0600ae524d2893de1b80 \
  --set-string config.nodes[1].keys.public=12D3KooWQWgT1rY6waQC2W6cERRRNKNLnpUCFMGrfXTng6grDX1R \
  --set config.nodes[1].validator=false \
  --set config.nodes[1].archive=false \
  --set config.nodes[1].bootnode=true \
  --set config.nodes[1].allowIngressP2P=false \
  --set config.nodes[1].allowIngressHttpRPC=false \
  --set config.nodes[1].allowIngressWsRPC=true \
  --set config.nodes[1].allowIngressPrometheus=false \
  --set config.nodes[1].telemetry=true \
  --set-string config.nodes[2].name=archive1 \
  --set-string config.nodes[2].keys.private=d0f95b692e4ce3c7fa62885255956ac2e283b1700c83b33b03bb7dbbb3243aa0 \
  --set-string config.nodes[2].keys.public=12D3KooWP16Xxu9G5v6JFrcphSBK15sjjUjyDZfYnb7bMAXAhmiR \
  --set config.nodes[2].validator=false \
  --set config.nodes[2].archive=true \
  --set config.nodes[2].bootnode=true \
  --set config.nodes[2].allowIngressP2P=false \
  --set config.nodes[2].allowIngressHttpRPC=false \
  --set config.nodes[2].allowIngressWsRPC=true \
  --set config.nodes[2].allowIngressPrometheus=false \
  --set config.nodes[2].telemetry=true \
  --set services.p2p.enabled=false \
  --set services.httpRPC.enabled=false \
  --set services.websocketRPC.enabled=true \
  --set services.prometheus.enabled=false \
  --set-string volume.storageClassName=premium-rwo \
  --set-string volume.dataSize=50Gi \
  --set-string nodeSelector.node_pool=general \
  --debug
kubectl rollout status statefulset/${REPOSITORY_NAME}-full1
