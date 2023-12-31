#!/usr/bin/env bash

set -e

echo "Uninstalling letsencrypt ClusterIssuer"
cat <<EOF | kubectl delete -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
  namespace: kube-system
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: devops@debio.network
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class: nginx
EOF

echo "Uninstalling cert-manager"
helm uninstall cert-manager --namespace kube-system