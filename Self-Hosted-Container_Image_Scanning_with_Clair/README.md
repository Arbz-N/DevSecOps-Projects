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


Project Structure

    ClairScan/
    │
    ├── clair-lab/
    │   └── Dockerfile               # BusyBox test image
    │
    ├── clair-setup/
    │   ├── docker-compose.yaml      # Clair + PostgreSQL services
    │   └── config/
    │       └── config.yaml          # Clair v4 configuration (required)
    │
    └── README.md                    # Project documentation


Prerequisites

Requirement                    Detail
Docker                         Installed (docker --version)
Docker Compose                 Installed (docker-compose --version)


Architecture


        clair-test:v1.0  (local Docker image)
                 │
                 │  clairctl report
                 ▼
          ┌────────────────────────────────────────┐
          │         Clair v4 (combo mode)          │
          │  :6060 API   :6061 Health              │
          │                                        │
          │  ┌──────────┐  ┌─────────┐ ┌───────-┐  │
          │  │ Indexer  │  │ Matcher │ │Notifier│  │
          │  │ (layers) │  │ (CVEs)  │ │(alerts)│  │
          │  └────┬─────┘  └────┬────┘ └───────-┘  │
          └───────┼─────────────┼─────────────────-┘
                  │             │
                  ▼             ▼
          ┌────────────────────────────────────────┐
          │         PostgreSQL 12                  │
          │         (CVE database + scan results)  │
          └────────────────────────────────────────┘
                 │
                 ▼
          Scan Report → CRITICAL / HIGH / MEDIUM / LOW



Step 1 — Build Test Image

    mkdir -p clair-lab && cd clair-lab
    
    docker build -t clair-test:v1.0 .
    
    docker images | grep clair-test
    # clair-test   v1.0   xxxx 


Step 2 — Create Clair Setup Directory

    mkdir -p clair-setup/config && cd clair-setup

Step 3 — Create config.yaml

    # config.yaml is already in clair-setup/config/ — apply it directly
    kubectl apply -f config/config.yaml

Step 4 — Start Clair with Docker Compose

    docker-compose up -d
    
    echo "First run downloads ~500MB CVE database — wait 3-5 minutes"

Step 5 — Verify Clair is Ready

    # Health check
    curl -s http://localhost:6061/healthz
    # {"status":"ok"} 
    
    # Container status
    docker-compose ps
    # clair-postgres   Up (healthy) 
    # clair            Up           
    
    # Clair logs
    docker logs clair --tail=10
    # "ready" 


Step 6 — Install clairctl

    curl -L https://github.com/quay/clair/releases/latest/download/clairctl-linux-amd64 \
      -o clairctl
    
    chmod +x clairctl
    sudo mv clairctl /usr/local/bin/
    
    clairctl version
    # clairctl v4.x.x 


Step 7 — Scan the Image

    cd ~/clair-lab
    
    clairctl --config clair-config.yaml \
      report \
      --host http://localhost:6060 \
      clair-test:v1.0


Cleanup
    cd ~/clair-lab/clair-setup
    docker-compose down -v
    
    docker rmi clair-test:v1.0 2>/dev/null
    cd ~ && rm -rf clair-lab/

License
    
    This project is licensed under the MIT License.