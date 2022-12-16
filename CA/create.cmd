mkdir private
mkdir certs
openssl genrsa -out private\cakey.pem 2048
openssl req -new -x509 -days 3650 -key private\cakey.pem -out certs\cacert.crt -subj "/CN=CA-SignPS"
openssl genrsa -out private\userkey.pem 2048
openssl req -new -key private\userkey.pem -reqexts v3_req -out certs\user.csr -nodes -subj "/CN=localhost"
openssl x509 -req -days 3650 -in certs\user.csr -CA certs\cacert.crt -CAkey private\cakey.pem -extfile v3.cfg -out certs\user.crt
