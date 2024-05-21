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
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-04ff98ccbfa41c9ad"
  instance_type = "t2.micro"
}

