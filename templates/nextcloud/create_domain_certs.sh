#/bin/bash
openssl req -x509 -newkey rsa:4096 -keyout privkey.pem -out fullchain.pem -nodes -config openssl.conf -days 30

cat >certs.yaml <<EOL
{
	"kind": "Secret",
	"apiVersion": "v1",
	"metadata": {
		"name": "nextcloud-cert",
		"namespace": "##__NAMESPACE__##"
		},
	"data": {
		"privkey.pem": "$(cat ./privkey.pem | base64 -w 0)",
		"fullchain.pem": "$(cat ./fullchain.pem | base64 -w 0)"
		}
}
EOL

rm privkey.pem
rm fullchain.pem

kubectl apply -f certs.yaml

rm certs.yaml
