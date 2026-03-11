# Self-Hosted Container Image Scanning with Clair v4


    Overview
    ClairScan is a hands-on project that sets up Clair v4 — a self-hosted, open-source container image vulnerability scanner — using Docker Compose. 
    It builds a test Docker image and scans it using clairctl, the official Clair v4 CLI, with a properly configured config.yaml and PostgreSQL backend.

    Key highlights:
    Clair v4 running in combo mode (Indexer + Matcher + Notifier in one container)
    PostgreSQL 12 as the CVE data store with Docker healthcheck
    config.yaml file-based configuration 
    migrations: true in all three sections to auto-create database tables
    clairctl v4 CLI used for scanning 


