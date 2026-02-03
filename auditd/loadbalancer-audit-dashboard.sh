#!/bin/bash

echo "════════════════════════════════════════════"
echo "  LOAD BALANCED SYSTEM AUDIT DASHBOARD      "
echo "  NGINX + Apache + MySQL Monitoring         "
echo "════════════════════════════════════════════"
echo ""
echo "Report Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# ========== NGINX LOAD BALANCER SECTION ==========
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "NGINX LOAD BALANCER MONITORING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Service Status:"
sudo systemctl is-active nginx && echo "Running" || echo "Stopped"
echo ""
echo "Configuration Changes (Last 24h):"

echo ""
echo "Configuration Changes (Last 24h):"
NGINX_CONFIG=$(sudo ausearch -k nginx_config_changes -i --start today 2>/dev/null | wc -l)
echo "   Events: $NGINX_CONFIG"

echo ""
echo "Process Events (Last 24h):"
NGINX_PROC=$(sudo ausearch -k nginx_process -i --start today 2>/dev/null | wc -l)
echo "   Events: $NGINX_PROC"

echo ""

#========== APACHE BACKEND 1 SECTION ==========
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "APACHE BACKEND 1 (Port 8080) MONITORING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Service Status:"
sudo netstat -tlnp 2>/dev/null | grep :8080 | grep -q apache2 && echo "Running" || echo "Stopped"

echo ""
echo "Configuration Changes (Last 24h):"
APACHE8080_CONFIG=$(sudo ausearch -k apache_8080_config -i --start today 2>/dev/null | wc -l)
echo "   Events: $APACHE8080_CONFIG"

echo ""
echo "Access Log Changes (Last 24h):"
APACHE8080_LOGS=$(sudo ausearch -k apache_8080_access_logs -i --start today 2>/dev/null | wc -l)
echo "   Events: $APACHE8080_LOGS"

echo ""

# ========== APACHE BACKEND 2 SECTION ==========
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "APACHE BACKEND 2 (Port 8081) MONITORING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Service Status:"
sudo netstat -tlnp 2>/dev/null | grep :8081 | grep -q apache2 && echo "Running" || echo "Stopped"

echo ""
echo "Configuration Changes (Last 24h):"
APACHE8081_CONFIG=$(sudo ausearch -k apache_8081_config -i --start today 2>/dev/null | wc -l)
echo "   Events: $APACHE8081_CONFIG"

echo ""
echo "Access Log Changes (Last 24h):"
APACHE8081_LOGS=$(sudo ausearch -k apache_8081_access_logs -i --start today 2>/dev/null | wc -l)
echo "   Events: $APACHE8081_LOGS"

echo ""

# ========== MYSQL DATABASE SECTION ==========
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "MYSQL DATABASE MONITORING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Service Status:"
sudo systemctl is-active mysql && echo "Running" || echo "Stopped"

echo ""
echo "Configuration Changes (Last 24h):"
MYSQL_CONFIG=$(sudo ausearch -k mysql_config_changes -i --start today 2>/dev/null | wc -l)
echo "   Events: $MYSQL_CONFIG"

echo ""
echo "Database Modifications (Last 24h):"
MYSQL_DATA=$(sudo ausearch -k mysql_logs_modified -i --start today 2>/dev/null | wc -l)
echo "   Events: $MYSQL_DATA"

echo ""
echo "Payment Database Access (Last 24h):"
MYSQL_PAYMENT=$(sudo ausearch -k mysql_payment_db_changes -i --start today 2>/dev/null | wc -l)
echo "   Events: $MYSQL_PAYMENT"

echo ""

# ========== WEB APPLICATION SECTION ==========
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "WEB APPLICATION MONITORING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Application Files Access (Last 24h):"
APP_ACCESS=$(sudo ausearch -k payment_application_files -i --start today 2>/dev/null | wc -l)
echo "   Events: $APP_ACCESS"

echo ""
echo "Main App File Changes (Last 24h):"
APP_MAIN=$(sudo ausearch -k payment_app_main_file -i --start today 2>/dev/null | wc -l)
echo "   Events: $APP_MAIN"

echo ""

# ========== SUMMARY STATISTICS ==========
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY STATISTICS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

TOTAL_EVENTS=$(grep -c "type=" /var/log/audit/audit.log 2>/dev/null || echo "0")
echo "Total Audit Events (All Time): $TOTAL_EVENTS"

echo ""
echo "   Services Activity Summary (Last 24h):"
echo "   NGINX Events: $((NGINX_CONFIG + NGINX_PROC))"
echo "   Apache 1 Events: $((APACHE8080_CONFIG + APACHE8080_LOGS))"
echo "   Apache 2 Events: $((APACHE8081_CONFIG + APACHE8081_LOGS))"
echo "   MySQL Events: $((MYSQL_CONFIG + MYSQL_DATA + MYSQL_PAYMENT))"
echo "   App Events: $((APP_ACCESS + APP_MAIN))"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Report End Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"