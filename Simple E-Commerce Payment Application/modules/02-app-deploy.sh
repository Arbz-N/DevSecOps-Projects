#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}PHASE 2: APPLICATION DEPLOYMENT${NC}"


echo -e "${YELLOW}[*] Creating directories...${NC}"
mkdir -p /var/www/payment/logs

echo -e "${YELLOW}[*] Copying application...${NC}"
