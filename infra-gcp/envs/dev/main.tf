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

# n8n on Cloud Run
module "n8n" {
  # source = "git::https://github.com/diegokalpa/platform-root.git//infra-gcp/modules/cloud-run" # Remote module
  # source = "../../modules/cloud-run" # Local module with relative path
  source = "/Users/diegocoral/DIEVOPS/REPOS/platform-root/infra-gcp/modules/cloud-run" # Local module with absolute path
  project_id   = var.project_id
  region       = var.region
  env          = var.env
  service_name = "n8n"
  image        = "n8nio/n8n:1.109.1"
  
  # Use existing service account
  allowed_service_accounts = ["ci-deployer@${var.project_id}.iam.gserviceaccount.com"]
  service_account          = "ci-deployer@${var.project_id}.iam.gserviceaccount.com"

  # n8n specific configuration
  container_port = 8080
  cpu_limit      = "1000m"
  memory_limit   = "512Mi"
  cpu_idle       = true

  # Environment variables specific to n8n - IDENTICAL TO RENDER
  environment_variables = {
    DB_POSTGRESDB_DATABASE = "postgres"
    DB_POSTGRESDB_PORT = "6543"
    DB_POSTGRESDB_SCHEMA = "public"
    DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED = "FALSE"
    DB_TYPE = "postgresdb"
    GENERIC_TIMEZONE = "America/Lima"
    N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS = "TRUE"
    N8N_PROTOCOL = "https"
    N8N_RUNNERS_ENABLED = "TRUE"
    TZ = "America/Lima"
    N8N_PORT = "8080"
    WEBHOOK_URL = "https://dev-n8n-1097007406093.us-central1.run.app"
    N8N_HOST = "dev-n8n-1097007406093.us-central1.run.app"
  }

  # Secret environment variables for Supabase
  secret_environment_variables = var.n8n_secret_environment_variables

  # Scaling configuration
  min_instances = 0
  max_instances = 2
}

# Random ID for webhook URL
resource "random_id" "suffix" {
  byte_length = 4
}

# Useful output to get n8n URL
output "n8n_url" {
  description = "URL where n8n is deployed"
  value       = module.n8n.service_url
}


