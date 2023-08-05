#!/usr/bin/env bash

set -e

echo "Installing Ingress"
./ingress/install-debio-node-ingress.sh
./ingress/install-debio-backend-ingress.sh
./ingress/install-debio-frontend-ingress.sh
./ingress/install-debio-genetic-analyst-ui-ingress.sh
./ingress/install-debio-customer-ui-ingress.sh
