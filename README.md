# OpenSSL-CA-Management
Scripts for OpenSSL Management

## `initCA.sh`: Create privkey and self-signed certificate for CA
1. [Optional] Customize initCA.sh variables:
```
shell> head initCA.sh 
...
WORKING_DIR="`pwd`/CA"
CONF_DIR="$WORKING_DIR/configs/CA"
CERTS_DIR="$WORKING_DIR/certs"
SIGNED_CERTS_DIR="$WORKING_DIR/signed_certs"
PRIVATE_DIR="$WORKING_DIR/private"
...
```
2. Make sure directories are created:
```
shell> tree CA/
CA
|-- certs
|-- configs
|   |-- CA
|   |   `-- sampleCA.cnf
|   `-- server
|       `-- sampleServer.cnf
|-- private
`-- signed_certs

6 directories, 2 files
```
3. Create your custom .cnf file based on your CA information (sampleCA.cnf is given as an example).
```
shell> diff CA/configs/CA/sampleCA.cnf CA/configs/CA/myCA.cnf 
47,52c47,52
< commonName                    = CA Root Certificate Authority
< countryName                   = ES
< stateOrProvinceName           = Madrid
< emailAddress                  = root@example.org
< 0.organizationName            = Organization Name
< organizationalUnitName                = SysAdmin Department
---
> commonName                    = My CA Root Certificate Authority
> countryName                   = US
> stateOrProvinceName           = California
> emailAddress                  = root@mydomain.com
> 0.organizationName            = My Organization
> organizationalUnitName                = My SysAdmin Department
```
4. Execute:
```
shell> ./initCA.sh 
[INFO]: Getting cnf files...
Available cnf files:
====================
0.-   /root/OpenSSL-CA-Management/CA/configs/CA/myCA.cnf
1.-   /root/OpenSSL-CA-Management/CA/configs/CA/sampleCA.cnf
     -> Select your cnf file index: 0
====================
[INFO]: Selected /root/OpenSSL-CA-Management/CA/configs/CA/myCA.cnf.
[INFO]: Command: 'openssl req -x509 -newkey rsa:2048 -out /root/OpenSSL-CA-Management/CA/certs/cacert.crt -outform PEM -days 3560'
[INFO]: Generate private key and CA certificate? [Y/n] Y
[INFO]: Setting openssl config file...
/root/OpenSSL-CA-Management/CA/configs/CA/myCA.cnf
[INFO]: Initializating /root/OpenSSL-CA-Management/CA/serial and /root/OpenSSL-CA-Management/CA/index.txt
Generating a RSA private key
..............................+++++
...........................+++++
writing new private key to './CA/private/cakey.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
```
5. Use your privkey and certificate:
```
shell> tree CA
CA
|-- certs
|   `-- cacert.crt
|-- configs
|   |-- CA
|   |   |-- myCA.cnf
|   |   `-- sampleCA.cnf
|   `-- server
|       `-- sampleServer.cnf
|-- index.txt
|-- private
|   `-- cakey.pem
|-- serial
`-- signed_certs

6 directories, 7 files
```
6. Show if certificate is OK.
```
shell> ./showCert.sh cacert
[INFO]: Certificate '/root/OpenSSL-CA-Management/CA/certs/cacert.crt' found! Show? [Y/n] Y
Certificate:                                                                                                              
    Data:
    ...
```

## `./generateServerCertRequest.sh`: Create privkey and certification request
1. [Optional] Customize generateServerCertRequest.sh variables:
```
shell> head generateServerCertRequest.sh 
...
WORKING_DIR="`pwd`/CA"
CONF_DIR="$WORKING_DIR/configs/server"
CERTS_DIR="$WORKING_DIR/certs"
SIGNED_CERTS_DIR="$WORKING_DIR/signed_certs"
PRIVATE_DIR="$WORKING_DIR/private"
...
```
2. Make sure directories are created.
3. Create your custom .cnf file based on your Server information (sampleServer.cnf is given as an example).
```
diff CA/configs/server/sampleServer.cnf CA/configs/server/myserver.mydomain.com.cnf 
7,12c7,12
< commonName            = server1.example.org
< countryName           = ES
< stateOrProvinceName   = Madrid
< emailAddress          = server@example.org
< organizationName      = Organization Name
< organizationalUnitName        = Sysadmin Department
---
> commonName            = server1.mydomain.com
> countryName           = US
> stateOrProvinceName   = California
> emailAddress          = server1@mydomain.com
> organizationName      = My Organization
> organizationalUnitName        = My Sysadmin Department
18,19c18,20
< DNS.1 = server.example.org
< DNS.2 = myserver.example.org
---
> DNS.1 = server.mydomain.com
> DNS.2 = myserver.mydomain.com
> DNS.3 = myserver.myotherdomain.com
```
4. Execute:
```
shell> ./generateServerCertRequest.sh 
[INFO]: Getting cnf files...
Available cnf files:
====================
0.-   /root/OpenSSL-CA-Management/CA/configs/server/myserver.mydomain.com.cnf
1.-   /root/OpenSSL-CA-Management/CA/configs/server/sampleServer.cnf
     -> Select your cnf file index: 0
====================
[INFO]: Selected /root/OpenSSL-CA-Management/CA/configs/server/myserver.mydomain.com.cnf.
Write server name: myserver.mydomain.com
[INFO]: Encrypted privkey with passphrase? [Y/n] n
[INFO]: Command: 'openssl req -newkey rsa:2048 -nodes -keyout /root/OpenSSL-CA-Management/CA/private/myserver.mydomain.com.pem -keyform PEM -out /root/OpenSSL-CA-Management/CA/private/myserver.mydomain.com.csr -outform PEM'
[INFO]: Generate private key and CertRequest for 'myserver.mydomain.com'? [Y/n] Y
[INFO]: Setting openssl config file...
/root/OpenSSL-CA-Management/CA/configs/server/myserver.mydomain.com.cnf
Generating a RSA private key
.........+++++
.............................................................................................+++++
writing new private key to '/root/OpenSSL-CA-Management/CA/private/myserver.mydomain.com.pem'
-----

shell> tree -a -P "myserver*" CA                                                        
CA
|-- certs
|-- configs
|   |-- CA
|   `-- server
|       `-- myserver.mydomain.com.cnf
|-- private
|   |-- myserver.mydomain.com.csr
|   `-- myserver.mydomain.com.pem
`-- signed_certs

6 directories, 3 files
```
## `./signCertWithCA.sh`: Sign certification requests with CA
1. Execute:
```
shell> ./signCertWithCA.sh
[INFO]: Getting cnf files...
Available cnf files:
====================
0.-   /root/OpenSSL-CA-Management/CA/configs/CA/myCA.cnf
1.-   /root/OpenSSL-CA-Management/CA/configs/CA/sampleCA.cnf
     -> Select your cnf file index: 0
====================
[INFO]: Selected /root/OpenSSL-CA-Management/CA/configs/CA/myCA.cnf.
Write server name: myserver.mydomain.com
[INFO]: Command: 'openssl ca -in /root/OpenSSL-CA-Management/CA/private/myserver.mydomain.com.csr -out /root/OpenSSL-CA-Management/CA/certs/myserver.mydomain.com.crt'
[INFO]: Sign 'myserver.mydomain.com' CertRequest? [Y/n] Y
[INFO]: Setting openssl config file...
/root/OpenSSL-CA-Management/CA/configs/CA/myCA.cnf
Using configuration from /root/OpenSSL-CA-Management/CA/configs/CA/myCA.cnf
Enter pass phrase for ./CA/private/cakey.pem:
Can't open ./CA/index.txt.attr for reading, No such file or directory
34371039232:error:02001002:system library:fopen:No such file or directory:/usr/src/crypto/openssl/crypto/bio/bss_file.c:72:fopen('./CA/index.txt.attr','r')
34371039232:error:2006D080:BIO routines:BIO_new_file:no such file:/usr/src/crypto/openssl/crypto/bio/bss_file.c:79:
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'server1.mydomain.com'
countryName           :PRINTABLE:'US'
stateOrProvinceName   :ASN.1 12:'California'
emailAddress          :IA5STRING:'server1@mydomain.com'
organizationName      :ASN.1 12:'My Organization'
organizationalUnitName:ASN.1 12:'My Sysadmin Department'
Certificate is to be certified until May 12 17:46:16 2029 GMT (3650 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
```
2. Show if certificate is OK.
```
shell> tree -P "myserver*" CA                                                            
CA
|-- certs
|   `-- myserver.mydomain.com.crt
|-- configs
|   |-- CA
|   `-- server
|       `-- myserver.mydomain.com.cnf
|-- private
|   |-- myserver.mydomain.com.csr
|   `-- myserver.mydomain.com.pem
`-- signed_certs

6 directories, 4 files

shell> cmp -s CA/signed_certs/01.pem CA/certs/myserver.mydomain.com.crt && echo "[*] Equal files" || echo "[*] Non equal files"                                                                                     
[*] Equal files
```
```
./showCert.sh myserver                                                            
[INFO]: Certificate '/root/OpenSSL-CA-Management/CA/certs/myserver.mydomain.com.crt' found! Show? [Y/n] Y                 
Certificate:                                                                                                              
    Data:
    ...
```
3. Show metainfo:
```
shell> cat CA/serial
02
shell> cat CA/index.txt
V       290512174616Z           01      unknown /CN=server1.mydomain.com/ST=California/C=US/emailAddress=server1@mydomain.com/O=My Organization/OU=My Sysadmin Department
```
