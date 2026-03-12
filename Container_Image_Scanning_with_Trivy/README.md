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


Setup — Variables

    export AWS_REGION=us-east-1
    export ACCOUNT_ID=$(aws sts get-caller-identity \
      --query Account --output text)
    export ECR_REPO=trivy-lab-app
    export IMAGE_TAG=v1.0
    
    echo "Account: $ACCOUNT_ID"
    echo "Region : $AWS_REGION"


Step 1 — Install Trivy

    sudo apt-get install -y wget apt-transport-https gnupg lsb-release
    
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | \
      sudo apt-key add -
    
    echo "deb https://aquasecurity.github.io/trivy-repo/deb \
      $(lsb_release -sc) main" | \
      sudo tee /etc/apt/sources.list.d/trivy.list
    
    sudo apt-get update && sudo apt-get install -y trivy
    
    trivy --version
    # Version: 0.x.x 

Step 2 — Build Test Images

    mkdir -p trivy-lab && cd trivy-lab
    
    # Build both images
    docker build -t $ECR_REPO:$IMAGE_TAG .
    docker build -f Dockerfile.fixed -t $ECR_REPO:v1.1-fixed .
    
    docker images | grep $ECR_REPO
    # trivy-lab-app   v1.0       
    # trivy-lab-app   v1.1-fixed 

Step 3 — Create ECR Repository and Push

    aws ecr create-repository \
      --repository-name $ECR_REPO \
      --region $AWS_REGION \
      --image-scanning-configuration scanOnPush=true
    
    export ECR_URI=$(aws ecr describe-repositories \
      --repository-names $ECR_REPO \
      --region $AWS_REGION \
      --query 'repositories[0].repositoryUri' \
      --output text)
    
    # Login and push
    aws ecr get-login-password --region $AWS_REGION | \
      docker login --username AWS --password-stdin \
      $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
    
    docker tag $ECR_REPO:$IMAGE_TAG $ECR_URI:$IMAGE_TAG
    docker push $ECR_URI:$IMAGE_TAG

Step 4 — Local Image Scan
 
    # Full scan
    trivy image $ECR_REPO:$IMAGE_TAG
    
    # CRITICAL and HIGH only
    trivy image \
      --severity CRITICAL,HIGH \
      $ECR_REPO:$IMAGE_TAG
    
    # Save JSON report
    trivy image \
      --format json \
      --output trivy-report.json \
      $ECR_REPO:$IMAGE_TAG


Step 5 — ECR Direct Scan

    # Scan ECR image directly — no local pull needed
    trivy image $ECR_URI:$IMAGE_TAG
    
    trivy image \
      --severity CRITICAL,HIGH \
      $ECR_URI:$IMAGE_TAG

Step 6 — Dockerfile Misconfiguration Scan

    # Scan original (misconfigured)
    trivy config Dockerfile
    
    # Scan fixed version
    trivy config Dockerfile.fixed

Actual Scan Results
    
    Report Summary
    ┌──────────────────┬────────────┬───────────────────┐
    │      Target      │    Type    │ Misconfigurations │
    ├──────────────────┼────────────┼───────────────────┤
    │ Dockerfile       │ dockerfile │         2         │  ← issues 
    ├──────────────────┼────────────┼───────────────────┤
    │ Dockerfile.fixed │ dockerfile │         0         │  ← clean 
    └──────────────────┴────────────┴───────────────────┘

    Finding 1 — DS-0001 (MEDIUM): latest tag used

    Cause:
      "latest" tag is unpredictable.
      Today's build → one image
      Tomorrow's build → different image (if base updated)
      No reproducible builds 
    
    Fix:
      FROM busybox:1.36.1   ← specific version 


    Cause:
      Kubernetes and Docker don't know if the container is healthy.
      App crashes → container shows "Running" 
      No automatic restart triggered.
    
    Fix:
      HEALTHCHECK --interval=30s --timeout=3s \
        CMD sh -c "test -f /myapp/sample.txt" || exit 1 

Step 7 — Secrets Scan

    # Scan image for hard-coded secrets
    trivy image \
      --scanners secret \
      $ECR_REPO:$IMAGE_TAG
    
    # Scan local filesystem
    trivy fs \
      --scanners secret \
      .
    
    # If a secret is found:
    # SECRET: AWS Access Key ID found
    # File: .env line 3
    # → Remove immediately and rotate the key 


Step 8 — CI/CD Security Gate

    The scan-pipeline-example.yaml file demonstrates a GitHub Actions pipeline that blocks deployment if any CRITICAL vulnerability is found.
    Key step in the pipeline:

    - name: Scan — FAIL if CRITICAL found
      run: |
        trivy image \
          --severity CRITICAL \
          --exit-code 1 \
          myapp:${{ github.sha }}
        # CRITICAL found → exit code 1 → pipeline FAIL → deploy bl


Cleanup

    bashaws ecr batch-delete-image \
      --repository-name $ECR_REPO \
      --image-ids imageTag=$IMAGE_TAG imageTag=v1.1-fixed \
      --region $AWS_REGION
    
    aws ecr delete-repository \
      --repository-name $ECR_REPO \
      --region $AWS_REGION \
      --force
    
    docker rmi $ECR_REPO:$IMAGE_TAG $ECR_REPO:v1.1-fixed 2>/dev/null

    cd ~ && rm -rf trivy-lab/

License

    This project is licensed under the MIT License.