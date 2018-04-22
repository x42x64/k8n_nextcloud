#/bin/bash
kubectl -n ##__NAMESPACE__## create configmap nginx-config --from-file=nginx.conf
