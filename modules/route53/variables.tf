variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "techdevops.co.uk"
}

variable "alb_dns_name" {
  description = "DNS name of the application load balancer"
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID of the application load balancer"
  type        = string
}

variable "domain_validation_options" {
  description = "Domain validation options for ACM certificate"
  type        = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
  default     = []
}
