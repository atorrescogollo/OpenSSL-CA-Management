#!/usr/local/bin/bash

cd `dirname $0`
WORKING_DIR="`pwd`/CA"
CONF_DIR="$WORKING_DIR/configs/CA"
CERTS_DIR="$WORKING_DIR/certs"
SIGNED_CERTS_DIR="$WORKING_DIR/signed_certs"
PRIVATE_DIR="$WORKING_DIR/private"

# Formating paths
fnfcount=0
WORKING_DIR=`realpath $WORKING_DIR`
(( fnfcount+=`echo $?` ))
CONF_DIR=`realpath $CONF_DIR`
(( fnfcount+=`echo $?` ))
SIGNED_CERTS_DIR=`realpath $SIGNED_CERTS_DIR`
(( fnfcount+=`echo $?` ))
CERTS_DIR=`realpath $CERTS_DIR`
(( fnfcount+=`echo $?` ))
PRIVATE_DIR=`realpath $PRIVATE_DIR`
(( fnfcount+=`echo $?` ))

# Colors
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

if [ $fnfcount -gt 0 ]; then
	echo -e "${RED}[ERROR]:${NC} $fnfcount directories not found. Please, review initial variables." >&2
	exit 1
fi


echo -e "${BLUE}[INFO]:${NC} Getting cnf files..."
i=0
while read file
do
	conffiles[ $i ]=$file
	(( i++ ))
done < <(ls $CONF_DIR/*.cnf 2> /dev/null)

if [ $i -eq 0 ]; then
	echo -e "${RED}[ERROR]:${NC} There are no config files availables in $CONF_DIR."
	echo -e "${RED}[ERROR]:${NC} Please, generate *.cnf files." >&2
	exit 2
fi

echo "Available cnf files:"
echo "===================="
i=0
for file in ${conffiles[@]}; do
	echo "$i.-   $file"
	(( i++ ))
done

read -p "     -> Select your cnf file index: " index
echo "===================="
if ! [[ "$index" =~ ^[0-9]+$ ]] || (( $index >= $i )); then
	echo -e "${RED}[ERROR]:${NC} Wrong selection!"
	exit 3
fi

CONF_FILE=${conffiles[$index]}
echo -e "${BLUE}[INFO]:${NC} Selected $CONF_FILE."

while [ "$name" = "" ]; do
	read -p "Write server name: " name
	if [ ! -f "$PRIVATE_DIR/$name.csr" ]; then
                echo -e "${RED}[ERROR]:${NC} '$PRIVATE_DIR/$name.csr' was not found."
                name=""
        fi
done

cmd="openssl ca -in $PRIVATE_DIR/$name.csr -out $CERTS_DIR/$name.crt"
echo -e "${BLUE}[INFO]:${NC} Command: '$cmd'"

echo -ne "${BLUE}[INFO]:${NC} Sign '$name' CertRequest? "
read -rp "[Y/n] " ok
if [[ "$ok" =~ ^(([yY])+|([\ ]*))$ ]]; then
	echo -e "${BLUE}[INFO]:${NC} Setting openssl config file..."
	export OPENSSL_CONF=$CONF_FILE
	printenv OPENSSL_CONF
	`$cmd`	
else
	echo -e "${RED}[ERROR]:${NC} Operation aborted"
fi

