#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${YELLOW}Phase 1, System Sertup${NC}"
echo ""

if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}[!] This script must be run as root user${NC}"
  exit 1
fi

echo -e "${YELLOW}[*] Updating System Package....${NC}"
apt-get update
apt-get upgrade -y

echo -e "${YELLOW}[*] Installing Packages....${NC}"
apt-get install -y \
    net-tools \
    nginx \
    apache2 apache2-utils libapache2-mod-php \
    mysql-server \
    php8.3 php8.3-fpm php8.3-mysql php8.3-common

echo -e "${GREEN}[+] System setup Compeleted${NC}"
echo ""