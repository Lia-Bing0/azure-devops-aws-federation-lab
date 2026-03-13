resource "aws_instance" "devsecops_lab" {

  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.insecure_ssh.id
  ]

  tags = {
    Name = "devsecops-federation-lab"
  }
}

resource "aws_security_group" "insecure_ssh" {

  name        = "devsecops-lab-insecure-sg"
  description = "Intentional insecure security group for Checkov demonstration"

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devsecops-insecure-sg"
  }
}