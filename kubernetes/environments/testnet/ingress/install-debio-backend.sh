#!/usr/bin/env bash

set -e

REPOSITORY_NAME=debio-backend
DNS=api.testnet.debio.network

echo "Installing ${REPOSITORY_NAME} Ingress"
cat <<EOF | kubectl apply -f -
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: ${REPOSITORY_NAME}
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    nginx.ingress.kubernetes.io/auth-realm: Authentication Required
    nginx.ingress.kubernetes.io/auth-secret: debio-backend-basic-auth
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/cors-allow-headers: DNT,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization,debio-api-key,jwt
    nginx.ingress.kubernetes.io/cors-allow-origin: '*'
    nginx.ingress.kubernetes.io/enable-cors: "true"
spec:
  ingressClassName: nginx
  rules:
  - host: ${DNS}
    http:
      paths:
      - backend:
          service:
            name: debio-backend
            port:
              number: 3000
        path: /
        pathType: ImplementationSpecific
  tls:
  - hosts:
    - ${DNS}
    secretName: ${DNS}-letsencrypt-tls
EOF
