#/bin/bash

NAMESPACE=nextcloud-ns
DOMAIN1=nextcloud.dev.jmj-works.com
DOMAIN2=office.dev.jmj-works.com
EMAIL=test@test.com

echo "$EMAIL"
mkdir $NAMESPACE
cp -R ./templates/* ./$NAMESPACE/

sed -i 's@##__NAMESPACE__##@'"$NAMESPACE"'@g' ./$NAMESPACE/*/*
sed -i 's@##__DOMAIN1__##@'"$DOMAIN1"'@g' ./$NAMESPACE/*/*
sed -i 's@##__DOMAIN2__##@'"$DOMAIN2"'@g' ./$NAMESPACE/*/*
sed -i 's@##__EMAIL__##@'"$EMAIL"'@g' ./$NAMESPACE/*/*

kubectl create namespace $NAMESPACE

cd $NAMESPACE

cd mysql
./create_secret.sh
kubectl apply -f DbAllConfig.yaml
cd ..

cd nextcloud
kubectl apply -f collabora.yaml
./create_admin_pw.sh
./dhparam.sh
#./create_domain_certs.sh
./create_nginx_configmap.sh
kubectl apply -f create_pvc.yaml
kubectl apply -f create_nginx_service.yaml
kubectl apply -f deployment.yaml
echo "..."
sleep 15s 
echo "Your login for user \"admin\" is:"
kubectl get secret -n nextcloud-ns nextcloud-pass -o yaml | grep "^  password: " | cut -d " " -f 4 | base64 --decode -
echo ""
echo "..."
sleep 20s
echo "Please set your DNS record for $DOMAIN1 and $DOMAIN2 within the next 10 minutes to:"
kubectl -n $NAMESPACE describe service nextcloud-nginx | grep "^LoadBalancer Ingress" -

