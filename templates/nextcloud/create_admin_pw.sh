#/bin/bash

kubectl -n ##__NAMESPACE__## create secret generic nextcloud-pass --from-literal=password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
