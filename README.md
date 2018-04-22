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
