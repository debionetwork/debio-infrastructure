#!/usr/bin/env bash

set -e

echo "Installing ingress-nginx-lb-dhparam Secret"
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  dhparam.pem: "LS0tLS1CRUdJTiBESCBQQVJBTUVURVJTLS0tLS0KTUlJQ0NBS0NBZ0VBM0YwUytHVzhGcTRwbk1pQThtR0FwZENQc1dnOWZMRTZXUTA0OTN4WWN6d0hQTmR6OEw3QgpCNVg4Q0NSNFU3UFA0MGNuZVIwcExOclFaTmtDOFVhbGJYSDd5NUZ2NVhXM1NxQzJDV0Yvdm9ZNHkvbHI4Ry9rCnQ5bFo5bGZrdjdWSFNqS2o2NldCbkF4V1htMHUyUzFiTTVtRGhwcmNkQWd5WXd2OEs3eHVrME5ZRXA0Z1lZUlYKWVBGblhpdEhMV0trd0Z6dzFPWnRUOVFSQkc4clNrL0haVm1pd2VyaTBzTnkwT0lQOHdpanplVGszYkN1R0RwVApvVDRrQVhmZ2hzRXVmMDNYazAvckJZeWdJRXpJNUx4bmJ0UjNmNjNzUWMxL0swMGdGdTE4dWhPbDAzNU4vNkdLCmtTVVJsZEZjNHBaOEc0Q3lkcXJ5ajlCVmZ3eHhxMWZCK0t6dXVrMU53blFSeDEzNStBU3RieG0zYmV3M3I5YWYKeW41SmZtd0lXMDlkS0duRFZ5anFuMTRlRUN3TE9kamVuU0xhd05pOU5iZTcrVW5oM1J2Y1UzZTZmVFNpSjQ0Twp6aUhJemZQZEUwelp2dTI1ZzdzZ2tpNWQyMmxPREZtYmlneHBDTEZvemhNRld3ekltRHNFbXpBdCtuSi8zLzI5CisxRks0a0J4SWwxeEF6Sk45cVhqbHdWWWJJTkhIL01BZk5uRTlRZEJJczlpUEZpK3RMMWdkZDc5THBWZFphNGgKRUg2a2dnV3dseGcyOVVWczB1M2RWMXF5VjdhdTBrMzZkelp5V3JoMGxWdTMrVSszd0xZVlh0clpBU0hpRlExcQo5UU5RbEk2bHNuWDI3dnJsTEtodmlsTHFIUk9SNUJ5cmZ4bTh6OWJDL0x4VnZiZU1ONC9ERmRzQ0FRST0KLS0tLS1FTkQgREggUEFSQU1FVEVSUy0tLS0tCg=="
kind: Secret
metadata:
  name: ingress-nginx-lb-dhparam
  namespace: kube-system
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
EOF

echo "Installing ingress-nginx-custom-header ConfigMap"
cat <<EOF | kubectl apply -f -
apiVersion: v1
data: 
  X-Frame-Options: "DENY" 
  X-Content-Type-Options: "nosniff"
  X-XSS-Protection: "0"
  Content-Security-Policy: "connect-src 'self' blob: https: wss:; default-src 'self'; font-src 'self' https:; form-action 'self' https:; frame-src 'self' https:; img-src 'self' blob: data: https:; manifest-src 'self'; media-src 'self' blob: https:; object-src 'none'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https:; script-src-attr 'self' 'unsafe-inline' 'unsafe-eval' https:; script-src-elem 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src-attr 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src-elem 'self' 'unsafe-inline' 'unsafe-eval' https:; worker-src 'self' blob:"
  Permissions-Policy: "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()"
  Referrer-Policy: "strict-origin-when-cross-origin"
kind: ConfigMap
metadata:
  name: ingress-nginx-custom-header
  namespace: kube-system
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
EOF

echo "Initializing ingress-nginx"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

echo "Installing ingress-nginx"
helm upgrade ingress-nginx ingress-nginx/ingress-nginx \
  --install \
  --namespace kube-system \
  --version 4.2.3 \
  --set controller.config.keep-alive=10 \
  --set controller.config.enable-ocsp="true" \
  --set controller.config.hsts-preload="true" \
  --set controller.config.force-ssl-redirect="true" \
  --set controller.config.ssl-protocols="TLSv1.3" \
  --set controller.config.ssl-ciphers="EECDH+AESGCM:EDH+AESGCM" \
  --set controller.config.ssl-dh-param=ingress-nginx-lb-dhparam \
  --set controller.config.add-headers=ingress-nginx-custom-header \
  --set controller.config.hide-headers="X-Powered-By"
