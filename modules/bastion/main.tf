resource "aws_security_group" "bastion" {
  name        = "${var.project}-${var.environment}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-bastion-sg"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.bastion_key
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id              = var.public_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.bastion.name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y mysql jq awscli
    echo "export PS1='\\[\\e[32m\\]\\u@\\h:\\[\\e[34m\\]\\w\\[\\e[0m\\]\\$ '" >> /home/ec2-user/.bashrc
    echo "alias ll='ls -la'" >> /home/ec2-user/.bashrc
    EOF

  tags = {
    Name        = "${var.project}-${var.environment}-bastion"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_eip" "bastion" {
  domain   = "vpc"
  instance = aws_instance.bastion.id

  tags = {
    Name        = "${var.project}-${var.environment}-bastion-eip"
    Environment = var.environment
    Project     = var.project
  }
}

# IAM Role for Bastion
resource "aws_iam_role" "bastion" {
  name = "${var.project}-${var.environment}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.project}-${var.environment}-bastion-profile"
  role = aws_iam_role.bastion.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "secrets_access" {
  name = "${var.project}-${var.environment}-bastion-secrets-access"
  role = aws_iam_role.bastion.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:*:*:secret:${var.project}/${var.environment}/*"
      }
    ]
  })
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "bastion" {
  name              = "/ec2/${var.project}-${var.environment}-bastion"
  retention_in_days = 30

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

# Data sources
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
