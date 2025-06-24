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

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "bastion_key" {
  description = "SSH key name for bastion host"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to connect to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # In production, restrict this to your IP ranges
}
