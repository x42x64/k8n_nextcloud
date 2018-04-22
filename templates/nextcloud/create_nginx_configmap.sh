#/bin/bash
kubectl -n ##__NAMESPACE__## create configmap nextcloud-config --from-file=nginx.conf
