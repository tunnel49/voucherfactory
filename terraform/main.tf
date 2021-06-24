terraform {
  backend "s3" {
    bucket = "tfstate.tunnel49.net"
    key    = "tunnel49/voucherfactory"
    region = "eu-west-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.42"
    }
  }

  required_version = ">=0.15.4"
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

#module "vpc" {
#  source  = "terraform-aws-modules/vpc/aws"
#  name    = "voucherfactory_vpc"
#  cidr    = "10.101.0.0/16"
#  
#  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
#  private_subnets = ["10.101.64.0/18","10.101.128.0/18","10.101.192.0/18"]
#  public_subnets  = ["10.101.1.0/24","10.101.2.0/24", "10.101.3.0/24"]
#
#  enable_nat_gateway = true
#  single_nat_gateway = false
#  one_nat_gateway_per_az = true
#}
#
