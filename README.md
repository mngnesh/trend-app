# Trend Application Deployment

## Technologies Used
- Docker
- Kubernetes (Kind)
- Terraform
- AWS EC2
- Jenkins
- DockerHub

## Deployment Steps
1. Dockerized React dist build using NGINX
2. Pushed image to DockerHub
3. Provisioned AWS infrastructure using Terraform
4. Installed Jenkins in EC2
5. Created Kubernetes cluster using Kind
6. Deployed application using Kubernetes YAML
7. Exposed service publicly

## Application Access
http://13.207.4.152:8081

## Kubernetes Commands
kubectl get pods
kubectl get svc

## Terraform Commands
terraform init
terraform apply

## Docker Commands
docker build -t trend-app .
docker push username/trend-app

## Jenkins
Configured Jenkins pipeline for CI/CD automation.

## Monitoring
Monitoring system to check the health.
