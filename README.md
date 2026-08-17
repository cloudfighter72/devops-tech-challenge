# ☁️ DevOps Tech Challenge 1

![afrosamurai.jpg](/images/afrosamurai.jpg "afrosamurai")

![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-%E2%89%A51.9-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![CloudFront](https://img.shields.io/badge/CloudFront-Edge_Security-yellow?style=for-the-badge&logo=amazon-aws)
![WAFv2](https://img.shields.io/badge/AWS_WAFv2-Real_Time_Logging-red?style=for-the-badge&logo=amazonaws)
![Bedrock](https://img.shields.io/badge/Amazon_Bedrock-Auto_IR-black?style=for-the-badge&logo=amazon-aws)
![Multi_Region](https://img.shields.io/badge/Multi_Region-Transit_Gateway-blue?style=for-the-badge)
![Observability](https://img.shields.io/badge/Observability-CloudWatch_&_Bedrock-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Production_Grade-success?style=for-the-badge)

---

## Repository

GitHub repository:

<https://github.com/cloudfighter72/devops-tech-challenge>

The repository is private and must be shared with the designated challenge reviewer:

`michaeltayo96@outlook.com`

---

## Project Overview

This project implements a containerized Node.js application deployed to AWS using Terraform.

The solution includes:

* React frontend
* Node.js backend API
* Docker containers
* Nginx
* Amazon ECR
* Amazon ECS/Fargate
* Application Load Balancer
* AWS VPC networking
* Security groups
* IAM roles
* ECS service auto scaling
* Jenkins infrastructure

Terraform is used to provision the AWS infrastructure as code.

The application was tested locally using Docker and deployed to AWS ECS/Fargate.

---

## Architecture

```text
                              Internet
                                 |
                                 v
                       Application Load Balancer
                                 |
                    +------------+------------+
                    |                         |
                  /api/*                     /*
                    |                         |
                    v                         v
             Backend Target             Frontend Target
                    |                         |
                    v                         v
              Node.js API                Nginx / React
                 :8080                        :80
                    |                         |
                    +------------+------------+
                                 |
                            AWS ECS/Fargate
```

The Application Load Balancer provides the public entry point for the application.

API requests matching `/api` and `/api/*` are routed to the backend service.

Normal web requests are routed to the frontend service.

---

## AWS Infrastructure

The infrastructure is deployed in AWS `us-east-2`.

The Terraform configuration provisions:

* Amazon VPC
* Internet Gateway
* Subnets
* Route tables
* Security groups
* Application Load Balancer
* ALB listener
* ALB target groups
* Amazon ECS cluster
* ECS Fargate services
* Amazon ECR repositories
* ECS service auto scaling
* IAM roles and policies
* EC2/Jenkins infrastructure

---

## Repository Structure

```text
Tech_Challenge_1/
├── 00-provider.tf
├── 01-igw.tf
├── 02-subnets.tf
├── 03-route_table.tf
├── 04-vpc.tf
├── 05-alb.tf
├── 06-ec2-jenkins.tf
├── 07-ecs.tf
├── 08-sg_ecs.tf
├── 09-ecs_auto_scaler.tf
├── 10-ecr.tf
├── 11-iam_ecs.tf
├── 12-iam_jenkins.tf
├── 13-sg_jenkins_ec2.tf
├── A-outputs.tf
├── .gitignore
├── README.md
└── node-ecs-challenge/
    ├── backend/
    │   ├── Dockerfile
    │   ├── package.json
    │   └── application source
    └── frontend/
        ├── Dockerfile
        ├── nginx.conf
        ├── package.json
        └── application source
```

---

## Prerequisites

Install the following software before deploying the project:

* Git
* AWS CLI
* Terraform 1.9 or later
* Docker Desktop
* Node.js and npm

Verify the installations:

```bash
git --version
aws --version
terraform version
docker --version
node --version
npm --version
```

Configure the AWS CLI:

```bash
aws configure
```

Verify AWS authentication:

```bash
aws sts get-caller-identity
```

The Terraform configuration uses:

```text
AWS Region: us-east-2
```

The AWS account used for deployment must have sufficient permissions to create the required VPC, ECS, ECR, ALB, IAM, EC2, and supporting resources.

---

## Installation

Clone the private repository:

```bash
git clone https://github.com/cloudfighter72/devops-tech-challenge.git
cd devops-tech-challenge
```

If the project files are contained in a subdirectory, navigate to the Terraform project root before running Terraform.

Initialize Terraform:

```bash
terraform init
```

Validate the Terraform configuration:

```bash
terraform validate
```

Format the Terraform files:

```bash
terraform fmt
```

Review the proposed infrastructure:

```bash
terraform plan
```

Apply the infrastructure:

```bash
terraform apply
```

Confirm the deployment when Terraform prompts for approval.

View the resulting outputs:

```bash
terraform output
```

---

## Docker

The application is Dockerized as required by the challenge.

There are separate Docker images for the frontend and backend.

### Frontend Docker Image

Navigate to the frontend:

```bash
cd node-ecs-challenge/frontend
```

Build the image:

```bash
docker build -t node-frontend:latest .
```

Verify the image exists:

```bash
docker images
```

Test the Nginx configuration:

```bash
docker run --rm node-frontend:latest nginx -t
```

Expected result:

```text
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Run the frontend locally:

```bash
docker run --rm -p 8081:80 node-frontend:latest
```

Open the application:

```text
http://localhost:8081
```

---

## Backend Docker Image

Navigate to the backend:

```bash
cd node-ecs-challenge/backend
```

Build the backend image:

```bash
docker build -t node-backend:latest .
```

Run the backend container using the port configured by the application:

```bash
docker run --rm -p 8080:8080 node-backend:latest
```

The backend API can then be tested with:

```bash
curl http://localhost:8080/api
```

The API returns JSON containing an application ID.

---

## Running the Application Locally

### Backend

From the backend directory:

```bash
npm install
npm start
```

The backend listens on port `8080`.

### Frontend

From the frontend directory:

```bash
npm install
npm start
```

The React development server can then be accessed using the URL displayed by the development server.

For the Dockerized production-style frontend:

```bash
docker build -t node-frontend:latest .
docker run --rm -p 8081:80 node-frontend:latest
```

Open:

```text
http://localhost:8081
```

---

## Amazon ECR

The Terraform configuration creates the required ECR repositories.

Authenticate Docker to ECR:

```bash
aws ecr get-login-password --region us-east-2 | \
docker login \
--username AWS \
--password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com
```

Build the images:

```bash
docker build -t node-frontend:latest ./node-ecs-challenge/frontend
docker build -t node-backend:latest ./node-ecs-challenge/backend
```

Tag the images using the ECR repository URLs:

```bash
docker tag node-frontend:latest <FRONTEND_ECR_REPOSITORY>:latest
docker tag node-backend:latest <BACKEND_ECR_REPOSITORY>:latest
```

Push the images:

```bash
docker push <FRONTEND_ECR_REPOSITORY>:latest
docker push <BACKEND_ECR_REPOSITORY>:latest
```

The ECS task definitions use the corresponding ECR images.

---

## ECS and Fargate

The application runs using Amazon ECS with AWS Fargate.

The frontend service uses:

```text
Container port: 80
```

The backend service uses:

```text
Container port: 8080
```

The ECS services are integrated with the Application Load Balancer and target groups.

Check ECS services:

```bash
aws ecs describe-services \
  --cluster node-cluster \
  --services frontend-service backend-service \
  --region us-east-2
```

Check running tasks:

```bash
aws ecs list-tasks \
  --cluster node-cluster \
  --region us-east-2
```

Force a new frontend deployment if the image has been updated:

```bash
aws ecs update-service \
  --cluster node-cluster \
  --service frontend-service \
  --force-new-deployment \
  --region us-east-2
```

Force a new backend deployment:

```bash
aws ecs update-service \
  --cluster node-cluster \
  --service backend-service \
  --force-new-deployment \
  --region us-east-2
```

---

## Application Load Balancer

The Application Load Balancer listens on HTTP port `80`.

The routing configuration is:

```text
/api
/api/*
    |
    v
Backend Target Group
    |
    v
Backend ECS Service
```

All other requests are routed to:

```text
Frontend Target Group
    |
    v
Frontend ECS Service
```

Check the ALB:

```bash
aws elbv2 describe-load-balancers \
  --region us-east-2
```

Check target health:

```bash
aws elbv2 describe-target-health \
  --target-group-arn <TARGET_GROUP_ARN> \
  --region us-east-2
```

---

## Nginx

Nginx serves the React production application.

The frontend Nginx configuration supports React client-side routing.

The configuration is designed so that the AWS Application Load Balancer controls the backend routing rather than relying on an unavailable ECS hostname.

A simplified frontend Nginx configuration is:

```nginx
server {
    listen 80;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri /index.html;
    }
}
```

The frontend should not attempt to resolve an ECS service using an unavailable hostname such as:

```text
http://backend:8080
```

The ALB is responsible for routing `/api` requests to the backend ECS target group.

---

## Jenkins

The Terraform project also provisions EC2/Jenkins infrastructure.

The Jenkins server is used as part of the deployment infrastructure.

The Jenkins server URL and access credentials are intentionally **not stored in this repository**.

They must be provided through the challenge submission form as requested by the assignment.

### Jenkins submission information

Provide the following in the submission form:

```text
Jenkins URL:
<YOUR_JENKINS_URL>

Username:
<YOUR_JENKINS_USERNAME>

Password:
<YOUR_JENKINS_PASSWORD>
```

Do not commit Jenkins credentials, passwords, private keys, or other secrets to GitHub.

---

## Deployment Verification

### Verify Terraform

```bash
terraform validate
```

### Verify ECS

```bash
aws ecs describe-services \
  --cluster node-cluster \
  --services frontend-service backend-service \
  --region us-east-2 \
  --query 'services[*].[serviceName,desiredCount,runningCount,pendingCount]' \
  --output table
```

A healthy service should have the expected number of running tasks and no unexpected pending tasks.

### Verify frontend

Use the deployed ALB URL:

```bash
curl http://<ALB-DNS-NAME>/
```

The response should contain the React application's HTML.

### Verify backend

```bash
curl http://<ALB-DNS-NAME>/api
```

The response should contain JSON with the backend-generated application ID.

### Browser verification

Open the deployed frontend URL in a browser.

The React application should load and display the ID returned from the backend API.

---

## Deployed Application

The deployed frontend is available through the Application Load Balancer.

Current deployment URL:

```text
http://node-app-alb-1381792515.us-east-2.elb.amazonaws.com/
```

The API endpoint is:

```text
http://node-app-alb-1381792515.us-east-2.elb.amazonaws.com/api
```

These URLs should be verified immediately before submitting the challenge because AWS resources can be changed or destroyed.

---

## Security

The repository is private.

The repository must be shared with:

```text
michaeltayo96@outlook.com
```

Sensitive information is excluded from Git using `.gitignore`.

The repository should not contain:

* AWS access keys
* AWS secret keys
* Terraform state
* Terraform state backups
* `.pem` files
* SSH private keys
* Jenkins passwords
* Environment files containing secrets
* API keys
* Docker registry credentials

Examples of excluded files:

```text
.terraform/
terraform.tfstate
terraform.tfstate.backup
*.pem
*.key
.env
.env.*
node_modules/
```

---

## Challenge Deliverables

The project submission requires the following:

### Private GitHub repository

The complete project is stored in:

<https://github.com/cloudfighter72/devops-tech-challenge>

The repository must remain private.

### Repository access

The private repository must be shared with:

```text
michaeltayo96@outlook.com
```

### Jenkins server

The Jenkins server URL and credentials are provided in the additional submission-form field.

Jenkins credentials are intentionally not included in the GitHub repository.

### Deployed frontend

The deployed frontend URL is provided in the additional submission-form field.

Current deployed frontend:

```text
http://node-app-alb-1381792515.us-east-2.elb.amazonaws.com/
```

### README

This README provides:

* Prerequisites
* Installation instructions
* Terraform deployment instructions
* Docker build instructions
* Local application instructions
* AWS deployment instructions
* ECS deployment instructions
* ALB configuration
* Nginx configuration
* Verification procedures
* Security considerations
* Submission requirements

### Dockerization

Both application components are Dockerized:

* React frontend
* Node.js backend

---

## Final Submission Checklist

Before submitting the challenge, verify all of the following:

* [ ] GitHub repository is private
* [ ] All project source code is pushed to GitHub
* [ ] Terraform configuration is committed
* [ ] Frontend Dockerfile is committed
* [ ] Backend Dockerfile is committed
* [ ] Nginx configuration is committed
* [ ] README is committed
* [ ] No AWS credentials are committed
* [ ] No Jenkins credentials are committed
* [ ] No `.pem` private key is committed
* [ ] Terraform state is excluded from Git
* [ ] Docker images build successfully
* [ ] Frontend container runs successfully
* [ ] Backend container runs successfully
* [ ] ECS services are running
* [ ] ALB is operational
* [ ] Frontend URL loads successfully
* [ ] `/api` returns the backend response
* [ ] Jenkins server is accessible
* [ ] Jenkins URL is entered into the submission form
* [ ] Jenkins credentials are entered into the submission form
* [ ] Frontend URL is entered into the submission form
* [ ] `michaeltayo96@outlook.com` has access to the private repository

---

## Useful Cleanup Command

When the challenge environment is no longer needed, Terraform can remove the AWS resources:

```bash
terraform destroy
```

Review the resources carefully before confirming the destroy operation.

---

## Technologies

* AWS
* Terraform
* Amazon VPC
* Amazon ECS
* AWS Fargate
* Amazon ECR
* Application Load Balancer
* IAM
* EC2
* Jenkins
* Docker
* Nginx
* Node.js
* React
* Git
* GitHub

---

## Project Status

The infrastructure and containerized application have been deployed and validated in AWS.

The frontend has been validated through Docker locally and through the AWS Application Load Balancer.

The backend API has been validated locally and through the deployed `/api` route.

The final submission requires the private GitHub repository to be shared with `michaeltayo96@outlook.com`, with the Jenkins URL, Jenkins credentials, and deployed frontend URL provided in the challenge submission form.
