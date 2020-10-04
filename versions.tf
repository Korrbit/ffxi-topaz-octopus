
terraform {
  required_version = ">= 0.13"
  required_providers {
    docker = {
      source = "terraform-providers/docker"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}