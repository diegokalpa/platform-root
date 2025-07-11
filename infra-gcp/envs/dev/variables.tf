variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "dievops-dev"
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

# Variables de entorno secretas para n8n con Supabase
variable "n8n_secret_environment_variables" {
  description = "Secret environment variables for n8n with Supabase"
  type = map(object({
    secret_name    = string
    secret_version = string
  }))
  default = {
    DB_TYPE = {
      secret_name    = "dev-db-type"
      secret_version = "latest"
    }
    DB_POSTGRESDB_HOST = {
      secret_name    = "dev-supabase-url"
      secret_version = "latest"
    }
    DB_POSTGRESDB_DATABASE = {
      secret_name    = "dev-supabase-database"
      secret_version = "latest"
    }
    DB_POSTGRESDB_USER = {
      secret_name    = "dev-supabase-user"
      secret_version = "latest"
    }
    DB_POSTGRESDB_PASSWORD = {
      secret_name    = "dev-supabase-password"
      secret_version = "latest"
    }
    N8N_ENCRYPTION_KEY = {
      secret_name    = "dev-n8n-encryption-key"
      secret_version = "latest"
    }
    N8N_JWT_SECRET = {
      secret_name    = "dev-n8n-jwt-secret"
      secret_version = "latest"
    }
  }
}

# Service account para Cloud Run
variable "cloud_run_service_account" {
  description = "Service account for Cloud Run services"
  type        = string
  default     = "ci-deployer@dievops-dev.iam.gserviceaccount.com"
}
