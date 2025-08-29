variable "project_id" {
  description = "The GCP project ID where n8n will be deployed"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "GOOGLE_CREDENTIALS" {
  description = "Google Cloud credentials"
  type        = string
  sensitive   = true
}

# Secret environment variables for n8n with Supabase
variable "n8n_secret_environment_variables" {
  description = "Secret environment variables for n8n with Supabase"
  type = map(object({
    secret_name    = string
    secret_version = string
  }))
  default = {
    DB_POSTGRESDB_PASSWORD = {
      secret_name    = "dev-n8n-db-password"
      secret_version = "latest"
    },
    DB_POSTGRESDB_USER = {
      secret_name    = "dev-n8n-db-user"
      secret_version = "latest"
    },
    DB_POSTGRESDB_HOST = {
      secret_name    = "dev-n8n-db-host"
      secret_version = "latest"
    },
    N8N_ENCRYPTION_KEY = {
      secret_name    = "dev-n8n-encryption-key"
      secret_version = "latest"
    }
  }
}

# Service account for Cloud Run
variable "cloud_run_service_account" {
  description = "Service account for Cloud Run services"
  type        = string
  default     = "ci-deployer@your-project-id.iam.gserviceaccount.com"
}
