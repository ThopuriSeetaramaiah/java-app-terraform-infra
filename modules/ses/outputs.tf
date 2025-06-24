output "identity_arn" {
  description = "ARN of the SES domain identity"
  value       = aws_ses_domain_identity.main.arn
}

output "verification_token" {
  description = "Verification token for the domain identity"
  value       = aws_ses_domain_identity.main.verification_token
}

output "dkim_tokens" {
  description = "DKIM tokens for the domain"
  value       = aws_ses_domain_dkim.main.dkim_tokens
}

output "ses_policy_arn" {
  description = "ARN of the SES send email policy"
  value       = aws_iam_policy.ses_send_email.arn
}

output "template_name" {
  description = "Name of the SES template"
  value       = aws_ses_template.notification.name
}
