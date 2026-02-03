#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}PHASE 5: NGINX LOAD BALANCER${NC}"
echo ""

echo -e "${YELLOW}[*] Creating NGINX config...${NC}"

cat > /etc/nginx/sites-available/loadbalancer << 'NGINX_CONFIG'
upstream payment_backends {
    server 127.0.0.1:8080 weight=1;
    server 127.0.0.1:8081 weight=1;
    keepalive 32;
}

server {
    listen 80 default_server;
    server_name localhost;

    access_log /var/log/nginx/loadbalancer_access.log;
    error_log /var/log/nginx/loadbalancer_error.log;

    gzip on;
    gzip_types text/plain text/css application/json;

    add_header X-Load-Balanced "nginx" always;

    location / {
        proxy_pass http://payment_backends;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }

    location ~* \.(jpg|jpeg|png|gif|css|js)$ {
        expires 1y;
    }
}
NGINX_CONFIG

ln -sf /etc/nginx/sites-available/loadbalancer /etc/nginx/sites-enabled/loadbalancer
rm -f /etc/nginx/sites-enabled/default

if nginx -t 2>&1 | grep -q "successful"; then
    echo -e "${GREEN}[+] NGINX config valid${NC}"
else
    echo -e "${RED}[!] NGINX config error!${NC}"
fi

echo ""
