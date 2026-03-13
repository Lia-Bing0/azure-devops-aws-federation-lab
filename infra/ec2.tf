resource "aws_security_group" "restricted_ssh" {
  name        = "devsecops-lab-restricted-sg"
  description = "Restricted security group for DevSecOps lab"

  ingress {
    description = "Allow SSH from internal CIDR only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow HTTPS outbound only"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devsecops-restricted-sg"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "devsecops-lab-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "devsecops-lab-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "devsecops_lab" {
  ami                  = "ami-0c7217cdde317cfec"
  instance_type        = "t3.micro"
  ebs_optimized        = true
  monitoring           = true
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  vpc_security_group_ids = [
    aws_security_group.restricted_ssh.id
  ]

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "devsecops-federation-lab"
  }
}