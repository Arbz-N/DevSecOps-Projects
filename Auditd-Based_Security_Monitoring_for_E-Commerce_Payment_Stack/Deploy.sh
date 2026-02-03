#!/bin/bash

#============================================================================
# This is main script that will trigger the all the scripts related to Auditd-Based_Security_Monitoring_for_E-Commerce_Payment_Stack
#==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)/auditd/scripts"

echo -e "${BLUE}===============================================${NC}"
echo -e "${BLUE}COMPLETE AUDITD DAEMON RULES DEPLOYMENT SCRIPT${NC}"
echo -e "${BLUE}     RULES + DASHBOARD + REPORT + CRONJOB     ${NC}"
echo -e "${BLUE}===============================================${NC}"

if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}[!]This script must be run as root${NC}"
  exit 1
fi
# ====================================================================
# PHASE 1: AUDITD INSTALLATION
# ====================================================================

echo -e "${YELLOW}════════════════════════════════════════════${NC}"
echo -e "${YELLOW}PHASE 1: AUDITD INSTALLATION${NC}"
echo -e "${YELLOW}════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}[*] Installing auditd...${NC}"
apt-get update -y
if ! command -v auditctl &>/dev/null; then
   apt-get install -y Auditd-Based_Security_Monitoring_for_E-Commerce_Payment_Stack audispd-plugins
fi


echo -e "${GREEN}[+] auditd installed${NC}"
echo ""

# ====================================================================
# PHASE 2: AUDIT RULES CONFIGURATION
# ====================================================================

echo -e "${YELLOW}════════════════════════════════════════════${NC}"
echo -e "${YELLOW}PHASE 2: AUDIT RULES CONFIGURATION${NC}"
echo -e "${YELLOW}════════════════════════════════════════════${NC}"
echo ""

# Create comprehensive rules file
echo -e "${YELLOW}[*] Creating audit rules...${NC}"

if [ ! -d "$SCRIPT_DIR" ]; then
    echo -e "${RED}[!] Modules directory not found at $SCRIPT_DIR${NC}"
    exit 1
fi

chmod +x "$SCRIPT_DIR/payment-web-db-stack.rules"

cp "$SCRIPT_DIR/payment-web-db-stack.rules" /etc/audit/rules.d/ || { echo "Copy failed"; exit 1; }

echo -e "${GREEN}[+] Audit rules created${NC}"
echo ""

# ====================================================================
# PHASE 3: LOAD RULES
# ====================================================================

echo -e "${YELLOW}[*] Loading audit rules...${NC}"

# Load new rules
augenrules --load

# Make sure Auditd-Based_Security_Monitoring_for_E-Commerce_Payment_Stack starts on boot
systemctl enable Auditd-Based_Security_Monitoring_for_E-Commerce_Payment_Stack
systemctl restart Auditd-Based_Security_Monitoring_for_E-Commerce_Payment_Stack


echo -e "${GREEN}[+] Audit rules loaded and auditd started${NC}"
echo ""

# ====================================================================
# PHASE 4: CREATE MONITORING SCRIPTS
# ====================================================================

echo -e "${YELLOW}════════════════════════════════════════════${NC}"
echo -e "${YELLOW}PHASE 4: MONITORING SCRIPTS${NC}"
echo -e "${YELLOW}════════════════════════════════════════════${NC}"
echo ""

chmod +x "$SCRIPT_DIR/payment-audit-dashboard.sh"
cp "$SCRIPT_DIR/payment-audit-dashboard.sh" /usr/local/bin/ || { echo "Copy failed"; exit 1; }

echo -e "${GREEN}[+] Monitoring dashboard created${NC}"
echo ""

chmod +x "$SCRIPT_DIR/payment-daily-audit-report.sh"
cp "$SCRIPT_DIR/payment-daily-audit-report.sh" /usr/local/bin/ || { echo "Copy failed"; exit 1; }

echo -e "${GREEN}[+] Daily report script created${NC}"
echo ""

# ====================================================================
# PHASE 5: CRON JOB SETUP
# ====================================================================

echo -e "${YELLOW}════════════════════════════════════════════${NC}"
echo -e "${YELLOW}PHASE 5: CRON JOB SETUP${NC}"
echo -e "${YELLOW}════════════════════════════════════════════${NC}"
echo ""

chmod +x "$SCRIPT_DIR/cronjob_setup.sh"
bash "$SCRIPT_DIR/cronjob_setup.sh"
echo -e "${GREEN}[+] Cron job added for daily audit report${NC}"

# ====================================================================
# PHASE 6: VERIFICATION
# ====================================================================

echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${BLUE}VERIFICATION${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Auditd Service Status:${NC}"
sudo systemctl status Auditd-Based_Security_Monitoring_for_E-Commerce_Payment_Stack --no-pager | head -5

echo ""
echo -e "${YELLOW}Audit Rules Loaded:${NC}"
RULES_COUNT=$(sudo auditctl -l | wc -l)
echo "Total Rules: $RULES_COUNT"

echo ""
echo -e "${YELLOW}Dashboard Verification:${NC}"
DASHBOARD_COUNT=$(payment-audit-dashboard.sh --test | wc -l)
echo "Total Rules: $DASHBOARD_COUNT"

echo ""
echo -e "${YELLOW}Cron Check:${NC}"
CRON_COUNT=$(sudo crontab -l -u root | grep payment-daily | wc -l )
if [ "$CRON_COUNT" -eq 0 ]; then
    echo -e "${RED}[!] Cron job not added correctly${NC}"
else
  echo "Total Rules: $CRON_COUNT"
fi

echo ""
echo -e "${YELLOW}Rule Categories:${NC}"
echo "  NGINX Rules: $(sudo auditctl -l | grep -c nginx || echo 0)"
echo "  Apache Rules: $(sudo auditctl -l | grep -c apache || echo 0)"
echo "  MySQL Rules: $(sudo auditctl -l | grep -c mysql || echo 0)"
echo "  App Rules: $(sudo auditctl -l | grep -c payment || echo 0)"

echo ""
echo -e "${YELLOW}Monitoring Scripts:${NC}"
ls -lh /usr/local/bin/payment* | awk '{print "  " $9 " (" $5 ")"}'

echo ""

