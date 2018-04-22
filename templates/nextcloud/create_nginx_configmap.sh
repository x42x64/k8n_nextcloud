#/bin/bash
kubectl -n ##__NAMESPACE__## create configmap nextcloud-config --form-file=nginx.conf
