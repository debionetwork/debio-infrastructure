#!/usr/bin/env bash

set -e

echo "Uninstalling ingress-nginx"
helm uninstall ingress-nginx --namespace kube-system

echo "Uninstalling ingress-nginx-custom-header ConfigMap"
cat <<EOF | kubectl delete -f -
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

echo "Uninstalling ingress-nginx-lb-dhparam secret"
cat <<EOF | kubectl delete -f -
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
