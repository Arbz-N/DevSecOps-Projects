# Container Image Scanning with Trivy

Overview

    TrivyScan is a hands-on project that demonstrates fast, comprehensive container image vulnerability scanning using Trivy by Aqua Security. 
    It covers OS package CVE scanning, Dockerfile misconfiguration detection, secrets scanning.
    
    
    Key highlights:
    
    Trivy installed as a single binary — no database server required
    Intentionally misconfigured Dockerfile surfaces two findings (DS-0001, DS-0026)
    Fixed Dockerfile.fixed passes with zero misconfigurations
    ECR image scanned directly via Trivy (no local pull needed)
    Secrets scan for hard-coded credentials detection
    GitHub Actions CI/CD pipeline example with --exit-code 1 security gate
    Real scan output documented with root cause and fix for each finding


Project Structure

        Container_Image_Scanning_with_Trivy/
        │
        ├── trivy-lab/
        │   ├── Dockerfile              # Intentionally misconfigured (DS-0001, DS-0026)
        │   ├── Dockerfile.fixed        # Fixed version (0 misconfigurations)
        │   └── scan-pipeline-example.yaml  # GitHub Actions CI/CD example
        │
        └── README.md                   # Project documentation

Prerequisites

    Requirement               Detail

    AWS Account               ECR, IAM permissions
    AWS CLI                   Installed and configured
    DockerInstalled           locally
    Ubuntu/Debian             For Trivy apt install


Architecture

            Developer
                  │
                  │  docker build
                  ▼
              ┌──────────────────────────────────────────────────┐
              │  trivy image (local)                             │
              │  ├── OS packages    → CVE database match         │
              │  ├── App deps       → pip/npm/gem/maven          │
              │  ├── Secrets        → AWS keys, passwords        │
              │  └── Misconfigs     → Dockerfile best practices  │
              └──────────────────────────────────────────────────┘
                  │
                  │  docker push
                  ▼
              Amazon ECR (scanOnPush=true)
                  │
                  │  trivy image ECR_URI:tag (direct ECR scan)
                  ▼
              Trivy Report
              ┌────────────────────────────────┐
              │  CRITICAL: 0                   │
              │  HIGH:     0                   │
              │  MEDIUM:   1    (DS-0001)      │
              │  LOW:      1   (DS-0026)       │
              └────────────────────────────────┘
                  │
                  ▼
              CI/CD Pipeline
              CRITICAL found? → FAIL  (deploy blocked)
              No CRITICAL?    → Push → Deploy 

