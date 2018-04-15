#/bin/bash
openssl req -x509 -newkey rsa:4096 -keyout privkey.pem -out fullchain.pem -nodes -subj '/CN=localhost' -days 30

cat >certs.yaml <<EOL
{
	"kind": "Secret",
	"apiVersion": "v1",
	"metadata": {
		"name": "nextcloud-cert"
		},
	"data": {
		"privkey.pem": "$(cat ./privkey.pem | base64)",
		"fullchain.pem": "$(cat ./fullchain.pem)"
		}
}
EOL

rm privkey.pem
rm fullchain.pem
