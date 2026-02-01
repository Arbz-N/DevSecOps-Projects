#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}PHASE 4: APACHE CONFIGURATION${NC}"
echo ""

echo -e "${YELLOW}[*] Configuring ports...${NC}"

cat > /etc/apache2/ports.conf << 'EOF'
Listen 8080
Listen 8081
EOF

echo -e "${YELLOW}[*] Creating Backend 1 (Port 8080)...${NC}"

cat > /etc/apache2/sites-available/payment-8080.conf << 'APACHE_8080'
<VirtualHost *:8080>
    ServerName localhost
    DocumentRoot /var/www/payment
    ErrorLog ${APACHE_LOG_DIR}/payment-8080_error.log
    CustomLog ${APACHE_LOG_DIR}/payment-8080_access.log combined

    <Directory /var/www/payment>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        AddHandler application/x-httpd-php .php
        <FilesMatch \.php$>
            SetHandler application/x-httpd-php
        </FilesMatch>
    </Directory>
</VirtualHost>
APACHE_8080

echo -e "${YELLOW}[*] Creating Backend 2 (Port 8081)...${NC}"

cat > /etc/apache2/sites-available/payment-8081.conf << 'APACHE_8081'
<VirtualHost *:8081>
    ServerName localhost
    DocumentRoot /var/www/payment
    ErrorLog ${APACHE_LOG_DIR}/payment-8081_error.log
    CustomLog ${APACHE_LOG_DIR}/payment-8081_access.log combined

    <Directory /var/www/payment>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        AddHandler application/x-httpd-php .php
        <FilesMatch \.php$>
            SetHandler application/x-httpd-php
        </FilesMatch>
    </Directory>
</VirtualHost>
APACHE_8081

echo -e "${YELLOW}[*] Enabling modules...${NC}"
a2enmod proxy 2>/dev/null || true
a2enmod proxy_http 2>/dev/null || true
a2enmod rewrite 2>/dev/null || true
a2enmod headers 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true

a2ensite payment-8080.conf 2>/dev/null || true
a2ensite payment-8081.conf 2>/dev/null || true
a2dissite 000-default.conf 2>/dev/null || true

if apache2ctl configtest 2>&1 | grep -q "Syntax OK"; then
    echo -e "${GREEN}[+] Apache config valid${NC}"
else
    echo -e "${RED}[!] Apache config error!${NC}"
fi

echo ""