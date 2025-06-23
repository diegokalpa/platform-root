terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source     = "git::https://github.com/diegokalpa/platform-root.git//infra-gcp/modules/network"
  env        = var.env
  region     = var.region
  project_id = var.project_id
  cidr_block = "10.70.0.0/17"
}
