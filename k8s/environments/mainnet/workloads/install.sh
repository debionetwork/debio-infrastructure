#!/usr/bin/env bash

set -e

echo "Installing Workloads"
./workloads/install-debio-background-worker.sh
./workloads/install-debio-backend.sh
./workloads/install-debio-frontend.sh
./workloads/install-debio-genetic-analyst-ui.sh
./workloads/install-debio-customer-ui.sh
