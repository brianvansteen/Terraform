terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# provider "aws" {
#   profile = "default"
#   region  = "us-east-1"
# }

# provider "aws" {
#   profile = "default"
#   region  = "eu-west-1"
#   alias   = "eu"
# }

provider "aws" {
  profile = "default"
  region = "us-east-2"
  alias = "east"
}

provider "aws" {
  profile = "default"
  region = "us-west-1"
  alias = "west"
}