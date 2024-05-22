terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
  alias   = "eu"
}

locals {
  project_name = "Cloud DR"
}

# resource "aws_instance" "example" {
#   ami           = "ami-04ff98ccbfa41c9ad"
#   instance_type = "t2.micro"
# }

# from terraform.tfvars
variable "instance_type" {
  type = string
}

resource "aws_instance" "web_server" {
  ami           = "ami-04ff98ccbfa41c9ad"
  instance_type = var.instance_type
  tags = {
    Name    = "WebServer"
    Project = "Project-${local.project_name}"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  providers = {
    aws = aws.eu
  }

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

output "public_ip" {
  description = "Instance public IP"
  value       = aws_instance.web_server.public_ip
}

output "public_subnets" {
  description = "Instance public DNS"
  value       = aws_instance.web_server.public_dns
}

