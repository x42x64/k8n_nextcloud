#/bin/bash

NAMESPACE=nextcloud-ns

mkdir $NAMESPACE
cp -R ./templates/* ./$NAMESPACE/

sed -i 's@##__NAMESPACE__##@'"$NAMESPACE"'@g' ./$NAMESPACE/*/*

kubectl create namespace $NAMESPACE

cd $NAMESPACE

cd mysql
./create_secret.sh
kubectl apply -f DbAllConfig.yaml

cd ..
cd nextcloud
./create_admin_pw.sh
./dhparam.sh
./create_domain_certs.sh
kubectl apply -f create_nginx_configmap.yaml
kubectl apply -f create_pvc.yaml
kubectl apply -f deployment.yaml
kubectl apply -f create_nginx_service.yaml