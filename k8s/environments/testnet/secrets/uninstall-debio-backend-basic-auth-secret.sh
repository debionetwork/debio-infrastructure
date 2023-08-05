#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=debio-network-testnet
REPOSITORY_OWNER=debionetwork
REPOSITORY_NAME=debio-backend
REPOSITORY_FULL_NAME=${REPOSITORY_OWNER}/${REPOSITORY_NAME}

echo "Uninstalling ${REPOSITORY_NAME}-basic-auth Secret"
kubectl delete secret ${REPOSITORY_NAME}-basic-auth

echo "Delete ${REPOSITORY_NAME}-basic-auth htpasswd"