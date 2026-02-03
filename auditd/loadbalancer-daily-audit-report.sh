#!/bin/bash

REPORT_DIR="/var/log/payment_audit_reports"
REPORT_FILE="$REPORT_DIR/payment_audit_$(date +%Y-%m-%d).txt"

mkdir -p $REPORT_DIR

{
  echo "════════════════════════════════════════════"
  echo "   WEB & DATABASE SECURITY MONITORING       "
  echo "   E-Commerce Platform Audit Report         "
  echo "════════════════════════════════════════════"
  echo ""

  echo "Report Generated: $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""

  # NGINX Status
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "NGINX MONITORING"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Status: $(systemctl is-active nginx)"
  echo "Process Changes (24h): $(sudo ausearch -k nginx_process -i --start today 2>/dev/null | wc -l)"
  echo "Config Changes (24): $(sudo ausearch -k nginx_config_changes -i --start today 2>/dev/null | wc -l)"
  echo "Process Events (24h): $(sudo ausearch -k nginx_process -i --start today 2>/dev/null | wc -l)"
  echo "Load balancer config changes (24): $(sudo ausearch -k nginx_lb_config -i --start today 2>/dev/null | wc -l )"
  echo "Load balancer enabled changes (24): $(sudo ausearch -k nginx_lb_enabled -i --start today 2>/dev/null | wc -l )"
  echo "Access logs changes (24): $(sudo ausearch -k nginx_access_logs -i --start today 2>/dev/null | wc -l )"
  echo "Error logs changes (24): $(sudo ausearch -k nginx_error_logs -i --start today 2>/dev/null | wc -l )"
  echo ""

  # Apache Status
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "APACHE MONITORING"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  #
  echo "Status: $(systemctl is-active apache2)"
  echo "Ports Changes (24h): $(sudo ausearch -k apache2_ports -i --start today 2>/dev/null | wc -l)"
  echo "Process Changes (24h): $(sudo ausearch -k apache_process -i --start today 2>/dev/null | wc -l)"

  echo "BACKEND 1 (8080)"
  echo "Config Changes (24h): $(sudo ausearch -k apache_8080_config -i --start today 2>/dev/null | wc -l)"
  echo "Enabled config Changes (24h): $(sudo ausearch -k apache_8080_enabled -i --start today 2>/dev/null | wc -l)"
  echo "Access logs changes (24h): $(sudo ausearch -k apache_8080_access_logs -i --start today 2>/dev/null | wc -l)"
  echo "Error logs changes (24): $(sudo ausearch -k apache_8080_error_logs -i --start today 2>/dev/null | wc -l )"
  echo ""
  echo "BACKEND 2 (8081)"
  echo "Config Changes (24h): $(sudo ausearch -k apache_8081_config -i --start today 2>/dev/null | wc -l)"
  echo "Enabled config Changes (24h): $(sudo ausearch -k apache_8081_enabled -i --start today 2>/dev/null | wc -l)"
  echo "Access logs changes (24h): $(sudo ausearch -k apache_8081_access_logs -i --start today 2>/dev/null | wc -l)"
  echo "Error logs changes (24): $(sudo ausearch -k apache_8081_error_logs -i --start today 2>/dev/null | wc -l )"
  echo ""

  # MySQL Status
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "MYSQL MONITORING"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Status: $(systemctl is-active mysql)"
  echo "Process Changes (24h): $(sudo ausearch -k mysql_process -i --start today 2>/dev/null | wc -l)"
  echo "Config Changes (24h): $(sudo ausearch -k mysql_config_changes -i --start today 2>/dev/null | wc -l)"
  echo "Logs Modifications (24h): $(sudo ausearch -k mysql_logs_modified -i --start today 2>/dev/null | wc -l)"
  echo "Error logs changes (24h): $(sudo ausearch -k mysql_error_log -i --start today 2>/dev/null | wc -l)"
  echo "Config file changes (24h): $(sudo ausearch -k mysql_conf_changes -i --start today 2>/dev/null | wc -l)"
  echo "Payment db changes (24h): $(sudo ausearch -k mysql_payment_db_changes -i --start today 2>/dev/null | wc -l)"
  echo ""

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "WEB APPLICATION MONITORING"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Main folder changes (24h): $(sudo ausearch -k payment_application_files -i --start today 2>/dev/null | wc -l)"
  echo "Logs Modifications (24h): $(sudo ausearch -k payment_app_logs -i --start today 2>/dev/null | wc -l)"
  echo "Php file changes (24h): $(sudo ausearch -k payment_app_main_file -i --start today 2>/dev/null | wc -l)"

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "SYSTEMD SERVICE MONITORING"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Main systemd changes (24h): $(sudo ausearch -k systemd_changes -i --start today 2>/dev/null | wc -l)"
  echo "Nginx service changes  (24h): $(sudo ausearch -k nginx_service -i --start today 2>/dev/null | wc -l)"
  echo "Apache service changes (24h): $(sudo ausearch -k apache_service -i --start today 2>/dev/null | wc -l)"
  echo "Mysql service changes (24h): $(sudo ausearch -k mysql_service -i --start today 2>/dev/null | wc -l)"

  # ========== SUMMARY STATISTICS ==========
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "SUMMARY STATISTICS"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  TOTAL_EVENTS=$(grep -c "type=" /var/log/audit/audit.log 2>/dev/null || echo "0")
  echo "Total Audit Events (All Time): $TOTAL_EVENTS"

  echo "   Services Activity Summary (Last 24h):"
  echo "   NGINX Events: $((NGINX_CONFIG + NGINX_PROC))"
  echo "   Apache 1 Events: $((APACHE8080_CONFIG + APACHE8080_LOGS))"
  echo "   Apache 2 Events: $((APACHE8081_CONFIG + APACHE8081_LOGS))"
  echo "   MySQL Events: $((MYSQL_CONFIG + MYSQL_DATA + MYSQL_PAYMENT))"
  echo "   App Events: $((APP_ACCESS + APP_MAIN))"
  echo "   Security Events: $((ACCESS_DENIED + SUDO_CMDS + SYS_CHANGES + NETWORK))"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Report End Time: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
} > "$REPORT_FILE"