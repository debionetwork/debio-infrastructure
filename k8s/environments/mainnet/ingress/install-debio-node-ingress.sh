#!/usr/bin/env bash

set -e

REPOSITORY_NAME=debio-genetic-analyst-ui
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
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"
    nginx.ingress.kubernetes.io/server-snippets: location / { proxy_http_version 1.1; proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection "upgrade"; }
    nginx.ingress.kubernetes.io/rewrite-target: /debionetwork/ae48005a0c7ecb4053394559a7f4069e
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
