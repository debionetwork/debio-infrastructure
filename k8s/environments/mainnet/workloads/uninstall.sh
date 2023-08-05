#!/usr/bin/env bash

set -e

echo "Uninstalling Workloads"
helm uninstall debio-customer-ui
helm uninstall debio-genetic-analyst-ui
helm uninstall debio-frontend
helm uninstall debio-backend
helm uninstall debio-background-worker
