Real-TimeOps: Complete End-to-End DevOps Automation Project

📘 1. Project Overview

Terraform & CloudFormation
AWS Services (EC2, VPC, EKS, LoadBalancer) 
Ansible
Docker
Kubernetes (EKS) → a smart manager that places these boxes in the right locations
Prometheus + Grafana
Git + GitHub → where all the code and instructions are documented

This project builds a real-world scalable environment:
Infrastructure is created via Terraform + CloudFormation
Configuration via Ansible
App packaged in Docker
Deployed to Amazon EKS
Exposed via LoadBalancer
Monitored using Prometheus & Grafana
<img width="1313" height="499" alt="1" src="https://github.com/user-attachments/assets/c84e3b12-0f7d-4616-a138-7b2d208e286e" />

🏗️ 2. Architecture Diagram

                    ┌───────────────────────────┐       
                    │         GitHub Repo        │
                    │   (Source Code + IaC)      │
                    └──────────────┬────────────┘
                                   │
                                   ▼
                        ┌───────────────────┐
                        │  Terraform +       │
                        │  CloudFormation    │
                        │ (Infrastructure)   │
                        └──────────┬────────┘
                                   │
               ┌───────────────────┴────────────────────┐
               │                                        │
               ▼                                        ▼
     ┌────────────────────┐                    ┌────────────────────┐
     │ AWS VPC + Subnets  │                    │   IAM + Security   │
     │ IGW, NAT, RTables  │                    │   Groups + Roles   │
     └──────────┬─────────┘                    └──────────┬─────────┘
                │                                          │
                ▼                                          ▼
       ┌────────────────┐                     ┌──────────────────────┐
       │ Amazon EKS     │<------------------->│  Worker Node Group   │
       └───────┬────────┘                     └──────────┬───────────┘
               │                                          │
               ▼                                          ▼
    ┌─────────────────────┐                   ┌────────────────────────┐
    │ Kubernetes Services │                   │ Flask App (Dockerized) │
    │ Deployments / Pods  │                   └──────────┬─────────────┘
    └──────────┬──────────┘                              │
               ▼                                          ▼
        ┌───────────────┐                       ┌─────────────────────┐
        │ LoadBalancer   │  <------------------->│   Prometheus +      │
        │ (ELB - Public) │                       │      Grafana         │
        └───────────────┘                       └─────────────────────┘
        

🧰 3. Tools & Technologies Used
Cloud Platforms

🟦 AWS (EC2, EKS, VPC, IAM, LoadBalancer, S3, CloudWatch)

Infrastructure as Code

🟩 Terraform
🟥 CloudFormation

Configuration Management
🟧 Ansible

Containers & Orchestration
🐳 Docker
☸️ Kubernetes (EKS)

Monitoring
🔵 Prometheus
🟠 Grafana

Version Control
🟣 Git + GitHub

🛠️ 4. Infrastructure Deployment (Terraform + CloudFormation)

This project follows a hybrid IaC approach, using:

✔ Terraform for VPC, Subnets, SGs, EC2, EKS
✔ CloudFormation for additional AWS-specific components like IAM, EKS add-ons, load balancer policies, etc.

Terraform Creates:

VPC (CIDR: 10.0.0.0/16)
Public + Private Subnets
Internet Gateway & NAT
Route Tables
Security Groups for EC2, EKS, LB
EC2 Instance for Ansible Control Node
EKS Cluster + Node Group (worker nodes)

CloudFormation Adds:
IAM roles & policies for EKS
EKS Add-ons (VPC CNI, kube-proxy, CoreDNS)
LoadBalancer + TargetGroup
Additional networking rules
Optional S3 bucket for artifacts

🔧 5. Configuration Management (Ansible)
The EC2 instance acts as a control node.
Ansible automates:
Installing Docker CE
Pulling and running your app container
Setting up Prometheus node exporter
Preparing EKS tools (kubectl, awscli, eksctl)
<img width="1366" height="372" alt="cloud formation" src="https://github.com/user-attachments/assets/c574d90e-f476-46a5-9b70-62a4728ebdb6" />
<img width="1340" height="364" alt="EKS" src="https://github.com/user-attachments/assets/90e92935-2b30-4531-b727-dc0cb84180df" />


📦 6. Containerization (Docker)

The application (Flask API) is:
Packaged with a Dockerfile
Exposes port 7070
Built locally & pushed to ECR (optional)
Pulled inside EKS cluster
<img width="1331" height="512" alt="dockerhub image created" src="https://github.com/user-attachments/assets/62a9633f-9923-4691-91aa-7ebda20708fa" />


FROM python:3.9
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["gunicorn", "-b", "0.0.0.0:7070", "app:app"]

☸️ 7. Kubernetes (EKS Deployment)

This project uses Amazon EKS to run and scale the application.
Kubernetes Objects Used:
Deployment
Service (LoadBalancer type)
ConfigMap
Namespace
HPA

📁 9. Project Structure
<img width="223" height="310" alt="image" src="https://github.com/user-attachments/assets/07f68874-e71e-4dec-a1f1-67d48de5f5fc" />

🐞 11. Common Errors & Fixes
❌ EC2 has no Public IP → Cannot SSH

✔ Add associate_public_ip_address = true

❌ EKS Service has empty endpoints

✔ targetPort didn’t match container’s actual port → fix to 7070

❌ Docker install fails on Ubuntu

✔ Add Docker repo GPG key correctly
✔ Run apt update

❌ LoadBalancer returns empty reply

✔ Pod not READY
✔ ReadinessProbe mismatch
✔ TargetGroup unhealthy
<img width="589" height="236" alt="plublic ip allocated by adding this in the main file" src="https://github.com/user-attachments/assets/0a3e6d48-2d98-4777-a05c-2c19fb14c03d" />
<img width="1198" height="501" alt="public ip not allocated" src="https://github.com/user-attachments/assets/af8461ff-912c-4d48-8fe5-e8df5d58730e" />

