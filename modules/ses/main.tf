resource "aws_ses_domain_identity" "main" {
  domain = var.domain_name
}

resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}

resource "aws_ses_domain_mail_from" "main" {
  domain           = aws_ses_domain_identity.main.domain
  mail_from_domain = "mail.${aws_ses_domain_identity.main.domain}"
}

resource "aws_ses_email_identity" "admin" {
  email = "admin@${var.domain_name}"
}

resource "aws_ses_email_identity" "noreply" {
  email = "noreply@${var.domain_name}"
}

# IAM Policy for SES access
resource "aws_iam_policy" "ses_send_email" {
  name        = "${var.project}-${var.environment}-ses-send-email"
  description = "Policy for sending emails via SES"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail",
          "ses:SendTemplatedEmail"
        ]
        Effect   = "Allow"
        Resource = [
          aws_ses_domain_identity.main.arn,
          aws_ses_email_identity.admin.arn,
          aws_ses_email_identity.noreply.arn
        ]
      }
    ]
  })
}

# SES Template for notifications
resource "aws_ses_template" "notification" {
  name    = "${var.project}-${var.environment}-notification"
  subject = "{{subject}}"
  html    = <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>{{subject}}</title>
</head>
<body>
  <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
    <h1>{{subject}}</h1>
    <p>{{message}}</p>
    <p>Regards,<br>The ${var.project} Team</p>
  </div>
</body>
</html>
EOF
  text    = <<EOF
{{subject}}

{{message}}

Regards,
The ${var.project} Team
EOF
}
