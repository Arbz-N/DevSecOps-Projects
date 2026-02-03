**Simple E-Commerce Payment Application**

    A production-ready payment processing system with NGINX load balancing and multi-backend Apache servers.

Project Structure

    Simple_E-Commerce_Payment_Application/
    ├── README.md                    # Documentation
    ├── Deploy.sh                    # Main deployment script
    ├── app/
    │   ├── index.php               # PHP application
    │   └── Deploy.sh               # App deployment handler
    └── modules/
        ├── 01-system-setup.sh      # Install packages
        ├── 02-app-deploy.sh        # Deploy app files
        ├── 03-mysql-setup.sh       # Setup database
        ├── 04-apache-config.sh     # Configure Apache
        └── 05-nginx-config.sh      # Configure NGINX

**Quick Start**

    sudo bash deploy.sh

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

    Round-robin load balancing across 2 backends
    Shared MySQL database for data consistency
    High availability - if one backend fails, other serves requests

**Database**

    Host: localhost
    Database: payment_db
    User: payment_user
    Password: payment_secure_2024

**Monitoring**

    bashtail -f /var/log/nginx/loadbalancer_access.log
    tail -f /var/log/apache2/payment-8080_access.log
    tail -f /var/log/apache2/payment-8081_access.log