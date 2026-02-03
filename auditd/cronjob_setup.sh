#!/bin/bash

echo -e "════════════════════════════════════════════"
echo -e "PHASE 5: CRON JOB SETUP"
echo -e "════════════════════════════════════════════"
echo ""

echo -e "[*] Setting up cron jobs..."

SCRIPT="/usr/local/bin/payment-daily-audit-report.sh"

# Ensure script is executable
chmod +x "$SCRIPT"

# Remove old entry safely
sudo crontab -u root -l 2>/dev/null | grep -v "$SCRIPT" | sudo crontab -u root - 2>/dev/null || true

# Add new cron job with logging
(sudo crontab -u root -l 2>/dev/null; echo "0 6 * * * $SCRIPT >> /var/log/payment-audit-cron.log 2>&1") | sudo crontab -u root -

echo -e "[+] Cron job configured successfully"
echo ""
