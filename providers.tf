terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  backend "s3" {
    bucket       = "firts-s3-itm"
    key          = "TerraformBasic/TerraformBasic.tfstate"
    use_lockfile = true
    region       = "us-east-1"
    encrypt      = true
    profile      = "PSeminario"
  }
}

# Configure and downloading plugins for AWS
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}