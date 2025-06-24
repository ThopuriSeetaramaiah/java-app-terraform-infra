# Java Application Infrastructure

This repository contains Terraform code to deploy a Java application infrastructure on AWS. The infrastructure is modular and environment-based, allowing for consistent deployments across development, staging, and production environments.

## Architecture

The infrastructure includes the following AWS services:

- **VPC**: Isolated network with public and private subnets across multiple availability zones
- **ECS**: Container orchestration for the Java application
- **Secrets Manager**: Secure storage for database credentials and application secrets
- **EC2 Bastion Host**: Secure access to resources in private subnets
- **RDS**: MySQL database for the application
- **Route53**: DNS management for the domain techdevops.co.uk
- **Lambda**: Serverless functions for background processing
- **SES**: Email service for sending notifications
- **EventBridge**: Event-driven architecture for scheduling and custom events

## Directory Structure

```
terraform/
├── modules/
│   ├── vpc/
│   ├── ecs/
│   ├── secretsmanager/
│   ├── bastion/
│   ├── rds/
│   ├── route53/
│   ├── lambda/
│   ├── ses/
│   └── eventbridge/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── main.tf
├── variables.tf
└── outputs.tf
```

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or newer
- S3 bucket for Terraform state
- DynamoDB table for state locking

## Usage

### Initialize Terraform

```bash
cd terraform/environments/dev
terraform init
```

### Plan the deployment

```bash
terraform plan
```

### Apply the changes

```bash
terraform apply
```

## Environment-specific Configuration

Each environment (dev, staging, prod) has its own configuration with appropriate sizing and settings:

- **Development**: Minimal resources for development and testing
- **Staging**: Medium-sized resources for pre-production testing
- **Production**: Highly available and scalable resources for production workloads

## Security Considerations

- All sensitive data is stored in AWS Secrets Manager
- Network isolation with public and private subnets
- Security groups with least privilege access
- Bastion host for secure access to private resources
- Encryption at rest and in transit

## Monitoring and Logging

- CloudWatch Logs for all services
- CloudWatch Alarms for critical metrics
- Enhanced monitoring for RDS

## Backup and Recovery

- RDS automated backups
- S3 versioning for artifacts
- Multi-AZ deployments for high availability

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
