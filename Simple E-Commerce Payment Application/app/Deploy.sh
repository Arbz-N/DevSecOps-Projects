#!/bin/bash

# ====================================================================
# COMPLETE PAYMENT APP DEPLOYMENT SCRIPT
# Payment App + Apache (2 Backends) + NGINX Load Balancer
# ====================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  COMPLETE PAYMENT APP DEPLOYMENT SCRIPT   ║${NC}"
echo -e "${BLUE}║  App + Apache + NGINX Load Balancer       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[!] This script must be run as root${NC}"
    exit 1
fi

if [ ! -d "$SCRIPT_DIR/modules" ]; then
    echo -e "${RED}[!] Modules directory not found at $SCRIPT_DIR/modules${NC}"
    exit 1
fi

MODULES=(
    "01-system-setup.sh"
    "02-app-deploy.sh"
    "03-mysql-setup.sh"
    "04-apache-config.sh"
    "05-nginx-config.sh"
)

echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${BLUE}EXECUTING DEPLOYMENT MODULES${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo ""

for module in "${MODULES[@]}"; do
    MODULE_PATH="$SCRIPT_DIR/modules/$module"

    if [ ! -f "$MODULE_PATH" ]; then
        echo -e "${RED}[!] Module not found: $MODULE_PATH${NC}"
        exit 1
    fi

    echo -e "${BLUE}[→] Executing module: $module${NC}"
    chmod +x "$MODULE_PATH"

    if bash "$MODULE_PATH"; then
        echo -e "${GREEN}[✓] Module completed: $module${NC}"
    else
        echo -e "${RED}[✗] Module failed: $module${NC}"
        exit 1
    fi

    echo ""
done

echo -e "${YELLOW}════════════════════════════════════════════${NC}"
echo -e "${YELLOW}PHASE 6: STARTING SERVICES${NC}"
echo -e "${YELLOW}════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}[*] Restarting services...${NC}"

systemctl restart apache2
systemctl restart nginx
systemctl restart mysql

systemctl enable apache2
systemctl enable nginx
systemctl enable mysql

echo -e "${GREEN}[+] All services started and enabled${NC}"
echo ""

echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${BLUE}VERIFICATION & SUMMARY${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Service Status:${NC}"
echo "NGINX:  $(systemctl is-active nginx)"
echo "Apache: $(systemctl is-active apache2)"
echo "MySQL:  $(systemctl is-active mysql)"
echo ""

echo -e "${GREEN}════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ COMPLETE DEPLOYMENT FINISHED!${NC}"
echo -e "${GREEN}════════════════════════════════════════════${NC}"
echo ""

echo -e "${BLUE}Access Application:${NC}"
echo "  🔗 Load Balanced:  http://localhost/"
echo "  🔗 Backend 1:      http://localhost:8080/"
echo "  🔗 Backend 2:      http://localhost:8081/"
echo ""