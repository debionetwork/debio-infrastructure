#!/usr/bin/env bash

set -e

echo "Uninstalling Secrets"
./secrets/uninstall-debio-backend-basic-auth-secret.sh
./secrets/uninstall-debio-background-worker-secrets-store.sh
./secrets/uninstall-debio-backend-secrets-store.sh
./secrets/uninstall-debio-frontend-secrets-store.sh
./secrets/uninstall-debio-genetic-analyst-ui-secrets-store.sh
./secrets/uninstall-debio-customer-ui-secrets-store.sh
