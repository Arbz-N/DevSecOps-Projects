#!/bin/bash
# Web & Database Stack Monitoring Rules
# =====================================

# Remove existing rules
-D

# Buffer and failure settings
-b 8192
-f 1

#========== WEB APPLICATION FILES ==========

-w  /var/www/payment/ -p rwa -k payment_application_files
-w /var/www/payment/logs -p rwa -k payment_app_logs
-w /var/www/payment/index.php -p rwa -k payment_app_main_file

# ========== APACHE RULES ==========

# Port configuration changes
-w /etc/apache2/ports.conf -p wa -k apache2_ports

# Backend 1 Configuration (Port 8080)
-w /etc/apache2/sites-available/payment-8080.conf -p wa -k apache_8080_config
-w /etc/apache2/sites-enabled/payment-8080.conf -p wa -k apache_8080_enabled

# Backend 1 Logs
-w /var/log/apache2/payment-8080_access.log -p wa -k apache_8080_access_logs
-w /var/log/apache2/payment-8080_error.log -p wa -k apache_8080_error_logs


# Backend 2 Configuration (Port 8081)
-w /etc/apache2/sites-available/payment-8081.conf -p wa -k apache_8081_config
-w /etc/apache2/sites-enabled/payment-8081.conf -p wa -k apache_8081_enabled

# Backend 2 Logs
-w /var/log/apache2/payment-8081_access.log -p wa -k apache_8081_access_logs
-w /var/log/apache2/payment-8081_error.log -p wa -k apache_8081_error_logs

# Apache configuration directory
-w /etc/apache2/mods-enabled/ -p wa -k apache_modules_enabled
-w /etc/apache2/conf-enabled/ -p wa -k apache_conf_enabled

# Apache process
-a exit,always -F arch=b64 -S execve -F exe=/usr/sbin/apache2 -k apache_process


# ========== MYSQL DATABASE ==========

# MySQL configuration
-w /etc/mysql/ -p wa -k mysql_config_changes
-w /etc/mysql/mysql.conf.d/ -p wa -k mysql_conf_changes

# MySQL logs
-w /var/log/mysql/error.log -p wa -k mysql_error_log
-w /var/log/mysql/ -p wa -k mysql_logs_modified

# MySQL data directory monitoring
-w /var/lib/mysql/payment_db/ -p wa -k mysql_payment_db_changes

# MYSQL process
-a exit,always -F arch=b64 -S execve -F exe=/usr/sbin/mysqld -k mysql_process


# ========== NGINX LOAD BALANCER ==========

# NGINX configuration files
-w /etc/nginx/sites-available/loadbalancer -p wa -k nginx_lb_config
-w /etc/nginx/sites-enabled/loadbalancer -p wa -k nginx_lb_enabled

# NGINX logs
-w /var/log/nginx/loadbalancer_access.log -p wa -k nginx_access_logs
-w /var/log/nginx/loadbalancer_error.log -p wa -k nginx_error_logs

# NGINX configuration directory
-w /etc/nginx/ -p wa -k nginx_main_config

# NGINX process
-a exit,always -F arch=b64 -S execve -F exe=/usr/sbin/nginx -k nginx_process


# Systemd service files
-w /etc/systemd/system/ -p wa -k systemd_changes
-w /lib/systemd/system/nginx.service -p wa -k nginx_service
-w /lib/systemd/system/apache2.service -p wa -k apache_service
-w /lib/systemd/system/mysql.service -p wa -k mysql_service



