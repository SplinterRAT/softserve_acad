module "vpc_mantis" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
  azs             = ["us-east-2a", "us-east-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    ita_group = "Lv-543"
  }
}

resource "aws_security_group" "mantis-sg" {
  name        = "mantis-sg"
  vpc_id      = module.vpc_mantis.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    ita_group = "Lv-543"
  }  
}


resource "aws_db_subnet_group" "mantis-subnet" {
  name       = "mantis-subnet"
  subnet_ids = flatten([module.vpc_mantis.public_subnets])

  tags = {
    ita_group = "Lv-543"
  }
}

