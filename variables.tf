variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-west-2" # London region
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "java-app"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "techdevops.co.uk"
}

variable "app_image" {
  description = "Docker image for the Java application"
  type        = string
}

variable "app_port" {
  description = "Port exposed by the Java application"
  type        = number
  default     = 8080
}

variable "app_count" {
  description = "Number of application containers to run"
  type        = number
  default     = 2
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units"
  type        = number
  default     = 1024 # 1 vCPU
}

variable "fargate_memory" {
  description = "Fargate instance memory"
  type        = number
  default     = 2048 # 2 GB
}

variable "bastion_key_name" {
  description = "SSH key name for bastion host"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.small"
}
