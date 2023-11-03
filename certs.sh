cd newcerts/

openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 365 -out ca.crt

openssl req -new -sha256 -keyout kong-tls.key -out kong-tls.csr -nodes -newkey rsa:2048 -subj "/CN=*.us-east-2.elb.amazonaws.com"

openssl x509 -req -in kong-tls.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kong-tls.crt -days 365 -sha256 -extfile <(printf "subjectAltName=DNS:.us-east-2.elb.amazonaws.com,DNS:us-east-2.elb.amazonaws.com")

cat kong-tls.crt ca.crt > kong-tls-bundle.crt
