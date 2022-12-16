set OPENSSL_CONF=C:\users\test\install\workbench\CA\openssl.cnf
rm -r certs
rm -r private 
mkdir private
mkdir certs
openssl genrsa -out private\cakey.pem 2048
openssl req -new -x509 -days 3650 -key private\cakey.pem -out certs\cacert.crt -subj "/CN=CA-SignPS"
openssl genrsa -out private\userkey.pem 2048
openssl req -new -key private\userkey.pem -reqexts v3_req -out certs\user.csr -nodes -subj "/CN=localhost"
openssl x509 -req -days 3650 -in certs\user.csr -CA certs\cacert.crt -CAkey private\cakey.pem -extfile .\v3.cfg -extensions v3_req -out certs\user.crt
openssl pkcs12 -export -in certs\user.crt -inkey private\userkey.pem -out certs\user.pfx -passout pass:
powershell "Import-PfxCertificate -FilePath certs\user.pfx -CertStoreLocation Cert:\LocalMachine\Root"
powershell "Import-Certificate -FilePath certs\cacert.crt -CertStoreLocation Cert:\LocalMachine\Root"
