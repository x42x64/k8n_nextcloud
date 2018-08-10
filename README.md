Inspiration from:
https://www.reddit.com/r/selfhosted/comments/7qa02n/setting_up_nextcloudfpm_nginx_mariadb_and/

# How to create secrets from literals
kubectl create secret generic <name_of_secret> --from-literal=<keyname>=<value>
kubectl create secret generic mysql-pass --from-literal=password=some_password

# How to create the dh parameters for PFS
./dhparam.sh 
This may take a while!

# How to create the initial certificates in order to fire up nginx
...

# Letsencrypt
https://runnable.com/blog/how-to-use-lets-encrypt-on-kubernetes

# What happens

3 containers in nextcloud pod:

1. nextcloud-fpm: PHP interpreter and nextcloud. The postStart hook executes:
  1. wait 45s (to have a chance that the database is up already)
  2. setup nextcloud with the database and the admin user
  3. adding trusted domains
  4. enabling richdocuments (collabora) app if it exists
  5. setting settings for collabora
  6. adding email to admin user account

2. certbot
  1. postStart hook: create self signed certificates and copy them into the volume certs in order to start nginx
  2. command/entrypoint: 
    1. wait 10 minutes (in order to set the DNS record appropriately)
    2. then start certbot with webroot plugin to sign certificates for the two domains
    3. copy the newly signed certificates to the certs volume
    4. every 12h: run certbot renew and copy the results to the certs volume

3. nginx
  1. start nginx
  2. wait 11 minutes
  3. every 62 minutes: reload nginx configuration in order to reload certificates if necessary

# How to start

Assumption: kubectl is set to gcloud cluster.

* In deploy_nextcloud.sh, set following variables at the beginning: 
  * NAMESPACE: kubernetes namespace, e.g. nextcloud-ns
  * DOMAIN1: Domain where nextcloud should be reachable
  * DOMAIN2: Domain where collabora should be reachable
  * EMAIL: Email for admin user and letsencrypt registration
* run deploy_nextcloud.sh
* setting dns records within 10 Minutes (A or AAAA record for DOMAIN1 and DOMAIN2 have to be set to ```kubectl -n $NAMESPACE describe service nextcloud-nginx | grep "^LoadBalancer Ingress" -```)
* get admin password: ```kubectl get secret -n nextcloud-ns nextcloud-pass -o yaml | grep "^  passwor--decode -| echo --f 4 | base64 -```
* wait 15 minutes
* now nextcloud should be reachable at DOMAIN1 with a valid certificate

# ToDo

* storage
* mail settings (password retrieval)
* ...


