provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    # This will be configured in each environment
  }
}

# VPC Module
module "vpc" {
  source      = "./modules/vpc"
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  azs         = var.availability_zones
  project     = var.project_name
}

# ECS Module
module "ecs" {
  source             = "./modules/ecs"
  environment        = var.environment
  project            = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnets
  public_subnets     = module.vpc.public_subnets
  app_image          = var.app_image
  app_port           = var.app_port
  app_count          = var.app_count
  fargate_cpu        = var.fargate_cpu
  fargate_memory     = var.fargate_memory
  depends_on         = [module.vpc]
}

# Secrets Manager Module
module "secretsmanager" {
  source      = "./modules/secretsmanager"
  environment = var.environment
  project     = var.project_name
}

# Bastion Host Module
module "bastion" {
  source          = "./modules/bastion"
  environment     = var.environment
  project         = var.project_name
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  bastion_key     = var.bastion_key_name
  depends_on      = [module.vpc]
}

# RDS Module
module "rds" {
  source              = "./modules/rds"
  environment         = var.environment
  project             = var.project_name
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnets
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  db_instance_class   = var.db_instance_class
  depends_on          = [module.vpc]
}

# Route53 Module
module "route53" {
  source           = "./modules/route53"
  environment      = var.environment
  project          = var.project_name
  domain_name      = var.domain_name
  alb_dns_name     = module.ecs.alb_dns_name
  alb_zone_id      = module.ecs.alb_zone_id
  depends_on       = [module.ecs]
}

# Lambda Module
module "lambda" {
  source      = "./modules/lambda"
  environment = var.environment
  project     = var.project_name
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets
  depends_on  = [module.vpc]
}

# SES Module
module "ses" {
  source      = "./modules/ses"
  environment = var.environment
  project     = var.project_name
  domain_name = var.domain_name
}

# EventBridge Module
module "eventbridge" {
  source      = "./modules/eventbridge"
  environment = var.environment
  project     = var.project_name
  lambda_arn  = module.lambda.lambda_arn
  depends_on  = [module.lambda]
}
