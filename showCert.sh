#!/usr/local/bin/bash

cd `dirname $0`
WORKING_DIR="`pwd`/CA"

# Colors
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

if [ $# -ne 1 ]; then
	echo -e "${RED}[ERROR]:${NC} Usage: $0 <file.crt>"
	exit 1
fi

certfile=`find $WORKING_DIR -type f -name "$1*.crt" | head -n 1`

if [[ ! -z "$certfile" ]]; then
	echo -ne "${BLUE}[INFO]:${NC} Certificate '$certfile' found! "
	read -rp "Show? [Y/n] " ok
	if [[ "$ok" =~ ^(([yY])+|([\ ]*))$ ]]; then
		openssl x509 -in $certfile -text -noout
		exit 0
	else
		echo -e "${RED}[ERROR]:${NC} Operation aborted"
	fi
else
	echo -e "${RED}[ERROR]:${NC} Certificate not found"
fi

echo -ne "${BLUE}[INFO]:${NC} "
read -rp "Search certificates by regex? [y/N] " ok
if [[ "$ok" =~ ^(([yY])+)$ ]]; then
	read -p "Regex: " regex
	echo
	echo "Found certificates:"
	echo "==================="
	find $WORKING_DIR -type f -name "*$regex*.crt" -exec basename {} \;
	echo
fi

