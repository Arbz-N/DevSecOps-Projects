# Auditd-Based Security Monitoring for E-Commerce Payment Stack

## Overview
This project provides a **comprehensive security monitoring solution** using **Auditd**, designed to track, log, and report changes across a typical e-commerce payment stack.
The setup focuses on monitoring:

- **NGINX Load Balancer**  
- **Apache Backend Servers**  
- **MySQL Databases**  
- **Web Application Files**  
- **Critical System Services (systemd)**  

The solution automates **rule deployment, monitoring scripts, and daily audit reports**, enabling DevSecOps teams to maintain visibility and security compliance across the infrastructure.
Auditd acts as the **primary audit daemon** on Linux systems, capturing system calls, configuration changes, process events, and user actions for real-time auditing and historical reporting.

> **Note:** 
    A simple PHP-based e-commerce payment application is included for **demo purposes only** to showcase Auditd monitoring in action.
    You can explore the demo here: [Simple E-Commerce Payment Application](/DevSecOps-Projects/Simple_E-Commerce_Payment_Application)
---
    Audit-Based_Security_Monitoring_for_E-Commerce_Payment_Stack/
    ├── README.md
    │   └── Project overview, setup, and documentation
    │
    ├── scripts/
    │   │
    │   ├── cronjob_setup.sh
    │   │   └── Automated cron job configuration for scheduled audits
    │   │
    │   ├── payment-audit-dashboard.sh
    │   │   └── Real-time audit log monitoring and dashboard display
    │   │
    │   ├── payment-daily-audit-report.sh
    │   │   └── Daily audit report generation and analysis
    │   │
    │   └── payment-web-db-stack.rules
    │       └── Auditd rules for comprehensive security monitoring
    │
    └──Deploy.sh
        └── Automated deployment and configuration script

---

## Features
- **Automated Auditd Deployment:** Install and configure `auditd` along with required plugins.
- **Comprehensive Rule Set:** Monitors critical system components, application files, and databases.
- **Dashboard Interface:** Interactive terminal-based dashboard to visualize audit events.
- **Daily Audit Reports:** Cron-based automation generates daily summaries of all key events.
- **Security Visibility:** Tracks unauthorized configuration changes, log modifications, and sensitive database activity.
- **DevSecOps Integration:** Easily integrates into existing CI/CD pipelines for continuous monitoring.

---

## Deployment & Usage

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd DevSecOps-Projects/auditd

**Run the deployment script as root:**

    sudo ./Deploy.sh

**The script will:**

    Install auditd and required plugins if missing
    Deploy the audit rules to /etc/audit/rules.d/
    Load rules into the audit daemon
    Deploy monitoring scripts to /usr/local/bin/
    Set up daily cron jobs for audit reports
    Verify service status and rule deployment

**Access the dashboard:**

    sudo /usr/local/bin/payment-audit-dashboard.sh

**View daily audit reports:**

    Reports are generated in /var/log/payment_audit_reports/ with timestamps.

**Auditd Overview**

    Auditd is the userspace component to the Linux Auditing System. It provides:
    Real-time monitoring of system calls and kernel events.
    Logging of security-related events for compliance and incident response.
    Customizable rules to track changes in files, processes, users, and network access.
    Integration with dashboards and automated reporting, enabling continuous security monitoring for production systems.

**Verification**

    After deployment, you can verify:

    Auditd service status:
    systemctl status auditd
    
    Rules loaded:
    sudo auditctl -l

    Cron job configuration:
    sudo crontab -l -u root | grep payment-daily

    Dashboard functionality:
    sudo /usr/local/bin/payment-audit-dashboard.sh --test


