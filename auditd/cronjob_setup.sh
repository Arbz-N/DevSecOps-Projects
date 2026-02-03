#!/bin/bash

echo -e "════════════════════════════════════════════$"
echo -e "PHASE 5: CRON JOB SETUP"
echo -e "════════════════════════════════════════════"
echo ""

# Daily report at 6 AM
echo -e "[*] Setting up cron jobs..."

sudo crontab -u root -l 2>/dev/null | grep -v "loadbalancer" | sudo crontab -u root - 2>/dev/null || true

(sudo crontab -u root -l 2>/dev/null; echo "0 6 * * * /usr/local/bin/loadbalancer-daily-audit-report.sh") | sudo crontab -u root -

echo -e "[+] Cron jobs configured"
echo ""