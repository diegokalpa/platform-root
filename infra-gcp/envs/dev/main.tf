terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  cloud {
    organization = "dievops"
    workspaces {
      name = "dievops-dev"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# n8n en Cloud Run
module "n8n" {
  source      = "git::https://github.com/diegokalpa/platform-root.git//infra-gcp/modules/cloud-run"
  project_id  = var.project_id
  region      = var.region
  env         = var.env
  service_name = "n8n"
  image       = "n8nio/n8n:latest"
}

# Output útil para obtener la URL de n8n
output "n8n_url" {
  description = "URL donde n8n está desplegado"
  value       = module.n8n.service_url
}
