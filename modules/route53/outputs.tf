output "zone_id" {
  description = "The ID of the hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "The name servers for the hosted zone"
  value       = aws_route53_zone.main.name_servers
}

output "domain_name" {
  description = "The domain name"
  value       = var.domain_name
}

output "website_endpoint" {
  description = "The website endpoint"
  value       = var.environment == "prod" ? "https://${var.domain_name}" : "https://${var.environment}.${var.domain_name}"
}
