terraform {
  cloud {
    organization = "dievops"
    workspaces {
      name = "dievops-dev"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
