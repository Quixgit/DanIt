terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-danit-devops-22"
    key            = "danit-devops-2/terraform.tfstate"
    region         = "eu-north-1"
  }
}

provider "aws" {
  region = "eu-north-1"
}

module "nginx_instance" {
  source            = "./modules/inst_nginx"
  vpc_id            = var.vpc_id
  list_of_open_ports = var.list_of_open_ports
}

output "instance_ip" {
  value       = module.nginx_instance.instance_ip
}