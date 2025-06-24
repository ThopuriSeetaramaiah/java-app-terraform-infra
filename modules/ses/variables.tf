variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for SES"
  type        = string
  default     = "techdevops.co.uk"
}
