terraform {
  required_version = "~> 1.2.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.27.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.21.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
