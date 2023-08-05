#!/usr/bin/env bash

set -e

echo "Installing Secrets"
./secrets/install-debio-backend-basic-auth-secret.sh
./secrets/install-debio-background-worker-secrets-store.sh
./secrets/install-debio-backend-secrets-store.sh
./secrets/install-debio-frontend-secrets-store.sh
./secrets/install-debio-genetic-analyst-ui-secrets-store.sh
./secrets/install-debio-customer-ui-secrets-store.sh
