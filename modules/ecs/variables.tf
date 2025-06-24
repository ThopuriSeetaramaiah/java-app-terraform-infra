variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "app_image" {
  description = "Docker image for the application"
  type        = string
}

variable "app_port" {
  description = "Port exposed by the application"
  type        = number
}

variable "app_count" {
  description = "Number of application containers to run"
  type        = number
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units"
  type        = number
}

variable "fargate_memory" {
  description = "Fargate instance memory"
  type        = number
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "techdevops.co.uk"
}
