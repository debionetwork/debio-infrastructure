#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=debio-network-testnet
REPOSITORY_OWNER=debionetwork
REPOSITORY_NAME=debio-backend
REPOSITORY_FULL_NAME=${REPOSITORY_OWNER}/${REPOSITORY_NAME}
PASSWORD=JmrVkuY8s04rhH1

echo "Create ${REPOSITORY_NAME}-basic-auth htpasswd"
htpasswd -cb auth ${REPOSITORY_NAME} ${PASSWORD}

echo "Installing ${REPOSITORY_NAME}-basic-auth Secret"
kubectl create secret generic ${REPOSITORY_NAME}-basic-auth --from-file=auth
rm auth
