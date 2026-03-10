resource "aws_instance" "devsecops_lab" {

  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t3.micro"

  tags = {
    Name = "devsecops-federation-lab"
  }
}