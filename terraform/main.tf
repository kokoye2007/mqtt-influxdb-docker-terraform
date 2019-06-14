terraform {
  required_version = ">= v1.1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.14.0"
    }
  }
  cloud {
    organization = "oss-tech"

    workspaces {
      name = "mqtt-influxdb-docker-terraform"
    }
  }
}

provider "aws" {
  region = var.aws_region
  #	access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
  #  profile = "default"
}

output "PACKER_EIP" {
  value = aws_eip.packer.public_ip
}
