provider "aws" {
  region = "us-east-1"
  profile = "default"
}
terraform {
  backend "s3" {
    bucket = "yourdomain-terraform"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.74"
    }
  }
}