#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=debio-network
REPOSITORY_OWNER=debionetwork
REPOSITORY_NAME=debio-node
REPOSITORY_FULL_NAME=${REPOSITORY_OWNER}/${REPOSITORY_NAME}
DOCKER_TAG=2.1.5

echo "Installing ${REPOSITORY_NAME}"
helm repo add debionetwork https://charts.debio.network
helm repo update
helm upgrade ${REPOSITORY_NAME} debionetwork/debio-node \
  --install \
  --set-string nameOverride=${REPOSITORY_NAME} \
  --set-string image.repository=${REPOSITORY_FULL_NAME} \
  --set-string image.tag=${DOCKER_TAG} \
  --set-string config.chain=mainnet \
  --set-string config.telemetryUrl="wss://telemetry.mainnet.octopus.network/submit 9" \
  --set-string config.nodes[0].name=full1 \
  --set-string config.nodes[0].keys.private=63e5abc6aaeaccaed1a036532df44fe024fdc94eeaf45f7365b9f45f02850f25 \
  --set-string config.nodes[0].keys.public=12D3KooWP1oDwZtMxH2i487XFWd4GYnxkpeYGSFsTsMqYYgKbLNJ \
  --set config.nodes[0].validator=false \
  --set config.nodes[0].archive=false \
  --set config.nodes[0].bootnode=true \
  --set config.nodes[0].allowIngressP2P=false \
  --set config.nodes[0].allowIngressHttpRPC=false \
  --set config.nodes[0].allowIngressWsRPC=true \
  --set config.nodes[0].allowIngressPrometheus=false \
  --set config.nodes[0].telemetry=true \
  --set-string config.nodes[1].name=full2 \
  --set-string config.nodes[1].keys.private=8ac4197b190e03e59d98ab3a8940842de79a76a2847bcc8f496ded4abfe49b13 \
  --set-string config.nodes[1].keys.public=12D3KooWGwWzZLx4pkhwzaSdR6dM9XkgJBwp91D5VqiUVQmFndZr \
  --set config.nodes[1].validator=false \
  --set config.nodes[1].archive=false \
  --set config.nodes[1].bootnode=true \
  --set config.nodes[1].allowIngressP2P=false \
  --set config.nodes[1].allowIngressHttpRPC=false \
  --set config.nodes[1].allowIngressWsRPC=true \
  --set config.nodes[1].allowIngressPrometheus=false \
  --set config.nodes[1].telemetry=true \
  --set-string config.nodes[2].name=archive1 \
  --set-string config.nodes[2].keys.private=25f2134e8539435948d8837b5127936cf10a2002ce4d9fe3a1553e2011a84186 \
  --set-string config.nodes[2].keys.public=12D3KooWE2yYqS2NpbwP8AEobG3JYWpWQ2FayahLJLnj7sQJeRX9 \
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
