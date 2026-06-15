# Phase 4 - Jenkins CI/CD Implementation

## Objective

Create a complete CI/CD pipeline for the Student Registration Enterprise DevOps Platform.

Pipeline:

```text
GitHub
↓
Jenkins
↓
Maven Build
↓
Unit Testing
↓
SonarQube Analysis
↓
Quality Gate
↓
OWASP Dependency Check
↓
Docker Build
↓
Trivy Scan
↓
Docker Hub
↓
AWS EKS Deployment
↓
Health Check
↓
Slack Notification
```

---

# Step 1: Launch Jenkins Server

Create EC2 Instance

```text
OS        : Ubuntu 22.04
Instance  : t3.large
Storage   : 30 GB
```

Security Group

```text
22    SSH

8080  Jenkins

9000  SonarQube
```

Connect

```bash
ssh -i key.pem ubuntu@<PUBLIC-IP>
```

---

# Step 2: Install Java 17

```bash
sudo apt update -y

sudo apt install openjdk-17-jdk -y
```

Verify

```bash
java -version
```

Expected

```text
openjdk version "17"
```

---

# Step 3: Install Jenkins
