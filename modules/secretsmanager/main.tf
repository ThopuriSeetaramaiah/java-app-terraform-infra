resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${var.project}/${var.environment}/db-password"
  description             = "Database password for ${var.environment} environment"
  recovery_window_in_days = var.environment == "prod" ? 30 : 7

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    password = var.db_password
  })
}

resource "aws_secretsmanager_secret" "app_secrets" {
  name                    = "${var.project}/${var.environment}/app-secrets"
  description             = "Application secrets for ${var.environment} environment"
  recovery_window_in_days = var.environment == "prod" ? 30 : 7

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_secretsmanager_secret_version" "app_secrets" {
  secret_id     = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode({
    SPRING_DATASOURCE_URL      = "jdbc:mysql://${var.db_endpoint}/${var.db_name}?useSSL=true&serverTimezone=UTC"
    SPRING_DATASOURCE_USERNAME = var.db_username
    JWT_SECRET                 = var.jwt_secret
    API_KEY                    = var.api_key
  })
}

# IAM Policy for accessing secrets
resource "aws_iam_policy" "secrets_access" {
  name        = "${var.project}-${var.environment}-secrets-access"
  description = "Policy for accessing secrets for ${var.project} in ${var.environment}"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = [
          aws_secretsmanager_secret.db_password.arn,
          aws_secretsmanager_secret.app_secrets.arn
        ]
      }
    ]
  })
}
