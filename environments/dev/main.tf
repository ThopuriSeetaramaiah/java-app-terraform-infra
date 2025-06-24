provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket         = "techdevops-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "techdevops-terraform-locks"
    encrypt        = true
  }
}

module "java_app" {
  source = "../../"
  
  environment        = "dev"
  project_name       = "java-app"
  aws_region         = "eu-west-2"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  domain_name        = "techdevops.co.uk"
  
  # ECS Configuration
  app_image      = "123456789012.dkr.ecr.eu-west-2.amazonaws.com/java-app:dev"
  app_port       = 8080
  app_count      = 1
  fargate_cpu    = 512
  fargate_memory = 1024
  
  # Bastion Configuration
  bastion_key_name = "dev-bastion-key"
  
  # RDS Configuration
  db_name           = "javaappdb"
  db_username       = "dbadmin"
  db_password       = "ChangeMe123!" # In production, use AWS Secrets Manager or similar
  db_instance_class = "db.t3.small"
}
