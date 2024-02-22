module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "hello-world-python2"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a"]
  public_subnets  = ["10.0.101.0/24"]
  private_subnets = ["10.0.1.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}






provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "my_security_group" {
  name        = "pythonapp-security-group"
  description = "python app security group"
  vpc_id      = module.vpc.vpc_id

  // Define your security group rules here
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["71.163.40.223/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "python-hello-world instance"

  instance_type          = "t2.micro"
  key_name               = "pythonappkey"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}