# Student Registration Enterprise DevOps Platform - Implementation Roadmap

## Project Overview

Student Registration Enterprise DevOps Platform is an enterprise-grade cloud-native application built using React, Spring Boot, and AWS RDS MariaDB.

The project demonstrates a complete DevOps lifecycle including:

* Docker Containerization
* Jenkins CI/CD
* SonarQube
* OWASP Dependency Check
* Trivy Security Scanning
* Terraform Infrastructure as Code
* AWS EKS
* Helm
* Prometheus
* Grafana
* CloudWatch
* DevSecOps Best Practices

---

# Current Architecture

```text
Frontend (React)
      │
      ▼
Backend (Spring Boot)
      │
      ▼
AWS RDS MariaDB
```

Current Infrastructure:

* AWS EC2
* AWS RDS MariaDB
* Docker

---

# Target Architecture

```text
GitHub
   │
   ▼
Jenkins
   │
   ├── SonarQube
   ├── OWASP Dependency Check
   ├── Trivy
   │
   ▼
Docker Build
   │
   ▼
Docker Hub
   │
   ▼
AWS EKS
   │
   ├── Frontend Pods
   ├── Backend Pods
   ├── ALB Ingress
   └── HPA
   │
   ▼
AWS RDS MariaDB
   │
   ▼
Prometheus
   │
   ▼
Grafana
   │
   ▼
CloudWatch
   │
   ▼
AlertManager
```

---

# Phase 1 – Verify Existing Application

## Backend Verification

Navigate to backend folder

```bash
cd backend
```

Build application

```bash
mvn clean package
```

Run application

```bash
java -jar target/*.jar
```

Verify API

```bash
curl http://localhost:8080
```

Expected:

```text
Spring Boot application running successfully
```

---

## Frontend Verification

Navigate to frontend folder

```bash
cd frontend
```

Install dependencies

```bash
npm install
```

Build frontend

```bash
npm run build
```

Run frontend

```bash
npm run dev
```

Verify:

```text
http://localhost:5173
```

Expected:

```text
React application running successfully
```

---

## Verify AWS RDS MariaDB

Connect from EC2

```bash
mysql -h <RDS-ENDPOINT> -u admin -p
```

Example

```bash
mysql -h student-registration-db.xxxxx.ap-south-1.rds.amazonaws.com -u admin -p
```

Verify database

```sql
SHOW DATABASES;
```

Expected

```text
student_db
```

Commit Code

```bash
git add .

git commit -m "Verified Student Registration application"

git push
```

---

# Phase 2 – Build Repository Structure

Create Project

```bash
mkdir Student-Registration-Enterprise

cd Student-Registration-Enterprise
```

Create Repository Structure

```bash
mkdir frontend
mkdir backend

mkdir -p jenkins

mkdir -p terraform/modules/vpc
mkdir -p terraform/modules/eks
mkdir -p terraform/modules/rds
mkdir -p terraform/modules/iam
mkdir -p terraform/modules/route53

mkdir -p terraform/environments/prod

mkdir -p kubernetes/frontend
mkdir -p kubernetes/backend
mkdir -p kubernetes/ingress
mkdir -p kubernetes/configmaps
mkdir -p kubernetes/secrets
mkdir -p kubernetes/hpa
mkdir -p kubernetes/rbac

mkdir -p helm/student-registration-chart

mkdir -p monitoring/prometheus
mkdir -p monitoring/grafana
mkdir -p monitoring/alertmanager
mkdir -p monitoring/cloudwatch

mkdir -p security/trivy
mkdir -p security/owasp
mkdir -p security/kubesec
mkdir -p security/policies

mkdir diagrams
mkdir scripts
```

Copy Existing Code

```bash
cp -r OLD_PROJECT/frontend/* frontend/

cp -r OLD_PROJECT/backend/* backend/
```

Commit

```bash
git add .

git commit -m "Repository structure created"

git push
```

---

# Phase 3 – Containerization

## Architecture

```text
Frontend Container
       │
       ▼
Backend Container
       │
       ▼
AWS RDS MariaDB
```

No MariaDB Docker Container.

AWS RDS MariaDB is the production database.

---

## Create Backend Dockerfile

Location

```text
backend/Dockerfile
```

Build Image

```bash
docker build -t student-registration-backend ./backend
```

Run Container

```bash
docker run -d \
-p 8080:8080 \
--name student-registration-backend \
student-registration-backend
```

---

## Create Frontend Dockerfile

Location

```text
frontend/Dockerfile
```

Build Image

```bash
docker build -t student-registration-frontend ./frontend
```

Run Container

```bash
docker run -d \
-p 3000:80 \
--name student-registration-frontend \
student-registration-frontend
```

Verify

```bash
docker ps
```

Expected

```text
student-registration-backend

student-registration-frontend
```

---

## Push Images to Docker Hub

Login

```bash
docker login
```

Tag Images

```bash
docker tag student-registration-backend anuragpatil/student-registration-backend:latest

docker tag student-registration-frontend anuragpatil/student-registration-frontend:latest
```

Push Images

```bash
docker push anuragpatil/student-registration-backend:latest

docker push anuragpatil/student-registration-frontend:latest
```

Commit

```bash
git add .

git commit -m "Dockerized Student Registration application"

git push
```

---

# Phase 4 – Jenkins CI/CD

Install

```text
Jenkins
Java 17
Maven
Docker
Trivy
kubectl
AWS CLI
SonarQube Scanner
```

Create

```text
jenkins/Jenkinsfile
```

Pipeline Flow

```text
GitHub
↓
Checkout
↓
Maven Build
↓
Unit Testing
↓
SonarQube
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

# Phase 5 – Terraform Infrastructure

Provision

* VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* EKS Cluster
* Managed Node Group
* AWS RDS MariaDB
* Application Load Balancer
* Route53
* IAM Roles
* S3 Backend

Deploy

```bash
terraform init

terraform validate

terraform plan

terraform apply
```

---

# Phase 6 – Kubernetes Deployment

Deploy

```bash
kubectl apply -f kubernetes/
```

Verify

```bash
kubectl get all -n student-registration
```

Expected

```text
Frontend Pods

Backend Pods

Services

Ingress

HPA
```

---

# Phase 7 – Helm

Create Chart

```bash
helm create student-registration-chart
```

Install

```bash
helm install student-registration helm/student-registration-chart
```

Upgrade

```bash
helm upgrade student-registration helm/student-registration-chart
```

Rollback

```bash
helm rollback student-registration 1
```

---

# Phase 8 – Monitoring

Install Stack

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack
```

Components

* Prometheus
* Grafana
* AlertManager
* Node Exporter
* kube-state-metrics

---

# Phase 9 – CloudWatch

Install CloudWatch Agent

```bash
helm install cloudwatch-agent amazon-cloudwatch/cloudwatch-agent
```

Enable

* Container Insights
* Logs
* Metrics
* Dashboards

---

# Phase 10 – Security

Implement

* SonarQube
* Trivy
* OWASP Dependency Check
* Kubernetes RBAC
* IAM Least Privilege
* Kubernetes Secrets

Verify

```bash
trivy image anuragpatil/student-registration-backend:latest

trivy image anuragpatil/student-registration-frontend:latest
```

---

# Kubernetes Namespace

```text
student-registration
```

---

# Docker Images

```text
anuragpatil/student-registration-backend

anuragpatil/student-registration-frontend
```

---

# EKS Cluster

```text
student-registration-eks
```

---

# Database

```text
AWS RDS MariaDB
```

---

# Expected Resume Achievements

* Reduced deployment time from 2 hours to under 10 minutes using Jenkins CI/CD automation.
* Automated AWS infrastructure provisioning using Terraform reducing setup effort by 90%.
* Implemented Kubernetes rolling deployments enabling zero-downtime releases.
* Achieved 99.9% application availability using AWS EKS and Application Load Balancer.
* Integrated SonarQube, OWASP Dependency Check and Trivy for automated DevSecOps scanning.
* Reduced Mean Time To Detect (MTTD) by 60% using Prometheus, Grafana, CloudWatch and AlertManager.
* Implemented Horizontal Pod Autoscaling to improve scalability and resource efficiency.
* Designed a cloud-native Student Registration platform using Docker, Kubernetes, Terraform and AWS.
