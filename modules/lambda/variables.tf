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

variable "subnet_ids" {
  description = "List of subnet IDs for Lambda VPC configuration"
  type        = list(string)
}

variable "lambda_bucket" {
  description = "S3 bucket containing Lambda deployment package"
  type        = string
  default     = "lambda-deployments"
}

variable "lambda_key" {
  description = "S3 key for Lambda deployment package"
  type        = string
  default     = "processor/index.zip"
}
