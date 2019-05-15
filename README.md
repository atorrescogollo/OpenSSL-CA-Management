# OpenSSL-CA-Management
Scripts for OpenSSL Management

## `initCA.sh`: Create privkey and self-signed certificate for CA
1. [Optional] Customize initCA.sh variables:
```
shell> head initCA.sh 
...
WORKING_DIR="`pwd`/CA"
CONF_DIR="$WORKING_DIR/configs"
CERTS_DIR="$WORKING_DIR/certs"
SIGNED_CERTS_DIR="$WORKING_DIR/signed_certs"
PRIVATE_DIR="$WORKING_DIR/private"
...
```
2. Make sure directories are created:
```
shell> tree CA/
CA/
|-- certs
|-- configs
|   `-- sampleCA.cnf
|-- private
`-- signed_certs

4 directories, 1 file
```
3. Create your custom .cnf file based on your CA information (sampleCA.cnf is given as an example).
```
shell> diff CA/configs/sampleCA.cnf CA/configs/myCA.cnf
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
> organizationalUnitName                = My CA SysAdmin Department
```
4. Execute:
```
shell> ./initCA.sh 
[INFO]: Getting cnf files...
Available cnf files:
====================
0.-   /root/OpenSSL-CA-Management/CA/configs/myCA.cnf
1.-   /root/OpenSSL-CA-Management/CA/configs/sampleCA.cnf
     -> Select your cnf file index: 0
====================
[INFO]: Selected /root/OpenSSL-CA-Management/CA/configs/myCA.cnf.
[INFO]: Command: 'openssl req -x509 -newkey rsa:2048 -out /root/OpenSSL-CA-Management/CA/certs/cacert.crt -outform PEM -days 3560'
[INFO]: Generate private key and CA certificate? [Y/n] Y
[INFO]: Setting openssl config file...
/root/OpenSSL-CA-Management/CA/configs/myCA.cnf
[INFO]: Initializating /root/OpenSSL-CA-Management/CA/serial and /root/OpenSSL-CA-Management/CA/index.txt
Generating a RSA private key
..................................................................................+++++
......+++++
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
|   |-- myCA.cnf
|   `-- sampleCA.cnf
|-- index.txt
|-- private
|   `-- cakey.pem
|-- serial
`-- signed_certs

4 directories, 6 files
```
