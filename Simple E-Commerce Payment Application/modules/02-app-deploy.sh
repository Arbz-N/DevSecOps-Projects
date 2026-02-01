#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}PHASE 2: APPLICATION DEPLOYMENT${NC}"
echo ""

echo -e "${YELLOW}[*] Creating directories...${NC}"
mkdir -p /var/www/payment/logs

echo -e "${YELLOW}[*] Copying application...${NC}"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
if [ -f "$SCRIPT_DIR/app/index.php" ]; then
    cp "$SCRIPT_DIR/app/index.php" /var/www/payment/index.php
    echo -e "${GREEN}[+] App deployed${NC}"
else
    echo -e "${RED}[!] App file not found${NC}"
    exit 1
fi

echo -e "${YELLOW}[*] Setting permissions...${NC}"
chown -R www-data:www-data /var/www/payment
chmod -R 755 /var/www/payment
chmod -R 777 /var/www/payment/logs

echo -e "${GREEN}[+] Application deployment completed${NC}"
echo ""
