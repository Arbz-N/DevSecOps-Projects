#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}PHASE 3: MYSQL DATABASE SETUP${NC}"
echo ""

echo -e "${YELLOW}[*] Starting MySQL...${NC}"
systemctl start mysql
systemctl enable mysql

echo -e "${YELLOW}[*] Creating database...${NC}"

mysql -e "
CREATE DATABASE IF NOT EXISTS payment_db;
CREATE USER IF NOT EXISTS 'payment_user'@'localhost' IDENTIFIED BY 'payment_secure_2024';
GRANT ALL PRIVILEGES ON payment_db.* TO 'payment_user'@'localhost';
FLUSH PRIVILEGES;

USE payment_db;

CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    product VARCHAR(100),
    amount DECIMAL(10, 2),
    card_last4 VARCHAR(4),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO payments (customer_name, customer_email, product, amount, card_last4, status) VALUES
('John Doe', 'john@example.com', 'smartphone', 599.99, '1234', 'completed'),
('Jane Smith', 'jane@example.com', 'laptop', 999.99, '5678', 'completed'),
('Mike Johnson', 'mike@example.com', 'smartwatch', 299.99, '9012', 'pending');
"

echo -e "${GREEN}[+] MySQL setup completed${NC}"
echo ""