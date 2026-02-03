**Payment App Complete Deployment**

    E-Commerce Payment Application with NGINX Load Balancer and Apache Multi-Backend Setup.

**Quick Start**

    bashsudo bash deploy.sh

**Architecture**

    User Browser
        ↓
    NGINX (Port 80) - Load Balancer
       /        \
    Apache 1  Apache 2
    (8080)    (8081)
       \        /
       MySQL Database
    Access

    Load Balanced: http://localhost/
    Backend 1: http://localhost:8080/
    Backend 2: http://localhost:8081/

**Database**

    Host: localhost
    Database: payment_db
    User: payment_user
    Password: payment_secure_2024

**Monitoring**

    bashtail -f /var/log/nginx/loadbalancer_access.log
    tail -f /var/log/apache2/payment-8080_access.log
    tail -f /var/log/apache2/payment-8081_access.log