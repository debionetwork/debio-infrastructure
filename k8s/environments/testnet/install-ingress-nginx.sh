#!/usr/bin/env bash

set -e

echo "Installing ingress-nginx-lb-dhparam Secret"
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  dhparam.pem: "LS0tLS1CRUdJTiBESCBQQVJBTUVURVJTLS0tLS0KTUlJQ0NBS0NBZ0VBbTdoZi8zQ21sOGQvcjFiRDkwaWYvUy9MOUFxNXpOMGoxYVg2MmU1NHlpQnVWLytmODl3ZQpTMXRiZHlzU0tXMEFXYzU3MWxBcFNSN3BpaXdHd0d3eHl6OUtucjQrQVBTWEt6VEloYUxnOVVIdkJZN2pyQmUvCmRxdEVNS3RhMFIvQ1Q4R2xCbkxuSjArQ1JOYTlwUWdjamtYMWFTaUd6UU9YbHZ0WGFnNUgxYitwSnhlOUUySkoKa05UOVUzL1ROT0grNTh3MnNQNVRNYXd0VnhlSEtnYTZWc1Bwanhsbkh1MDdONDlKRXJHQWhBTlI2d01iWXovagpIZ2hPQWx3RkRndkZ2MEJ2Y3dCNWx4UFJLY0k1YmdhclJMdk1VckZibWZhSjZ1Vkc5RlU3MnZzY2JNRVYvOG1UCkM1VlZvK00zbUxBWmtaNnlFVVNiTzYyL2Rnblhyd1lqNkg0UXM2VG9IUjN3RU1pNHltdmFOSWxzTkJkNHU0R2kKZkU4UmYvQmo4Q2l1TVFVT3hwWEwwK3hWYTVMQlBZdmFVVzhGQ2t6VFN2Z2hkRGF5RERqUGxIMVphZXZ6cUVRZwpreDJvMjEvdldHMm9lTjVIRGNJZlBTRmdIdU5HRjMxdVBEMENMMCtoeFRSVjAyNGtCeDFMYm5yWmJUS2NYMSszCkZvOTUwbXNacm1XVjluVTdhbTVERDJxY2d2UzRjZmxQM1lzVUUrSU5aSkVRRUZVZysxSGJ2d2Zod29BOXViVzQKaVRjV2piQWlJdFFJb0d4aFdSN3Z3bGdtY3gyOWMxL0JOVG1EZVhVUjVsU3hWa3BSRjJIRGdFMVhKTnU0VVNpRwpaNmNCRTZkSWRSdE5uTUcxdXBIdHNOeUUySTZmejU0a2hoUWFOb0ZKeXl4b0M4VXlhMEJGdHNzQ0FRST0KLS0tLS1FTkQgREggUEFSQU1FVEVSUy0tLS0tCg=="
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
