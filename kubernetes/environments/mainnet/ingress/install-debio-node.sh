#!/usr/bin/env bash

set -e

REPOSITORY_NAME=debio-node
DNS=ws-rpc.debio.network

echo "Installing ${REPOSITORY_NAME} Websocket RPC External Service"
cat <<EOF | kubectl apply -f -
kind: Service
apiVersion: v1
metadata:
  name: ${REPOSITORY_NAME}-websocket-rpc-external-service
spec:
  type: ExternalName
  externalName: gateway.mainnet.octopus.network
  ports:
  - port: 443
EOF

echo "Installing ${REPOSITORY_NAME} Websocket RPC Ingress"
cat <<EOF | kubectl apply -f -
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: ${REPOSITORY_NAME}-websocket-rpc
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/upstream-vhost: gateway.mainnet.octopus.network
    nginx.ingress.kubernetes.io/rewrite-target: /debionetwork/ae48005a0c7ecb4053394559a7f4069e
    nginx.ingress.kubernetes.io/server-snippet: |
      proxy_ssl_name gateway.mainnet.octopus.network;
      proxy_ssl_server_name on;
spec:
  ingressClassName: nginx
  rules:
  - host: ${DNS}
    http:
      paths:
      - backend:
          service:
            name: ${REPOSITORY_NAME}-websocket-rpc-external-service
            port:
              number: 443
        path: /
        pathType: ImplementationSpecific
  tls:
  - hosts:
    - ${DNS}
    secretName: ${DNS}-letsencrypt-tls
EOF
