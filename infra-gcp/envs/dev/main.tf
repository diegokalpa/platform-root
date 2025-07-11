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
  source       = "git::https://github.com/diegokalpa/platform-root.git//infra-gcp/modules/cloud-run"
  project_id   = var.project_id
  region       = var.region
  env          = var.env
  service_name = "n8n"
  image        = "n8nio/n8n:latest"

  # Configuración específica para n8n
  container_port = 5678
  cpu_limit      = "1000m"
  memory_limit   = "512Mi"

  # Variables de entorno específicas de n8n
  environment_variables = {
    ENVIRONMENT      = var.env
    N8N_HOST         = "0.0.0.0"
    N8N_PORT         = "5678"
    N8N_PROTOCOL     = "https"
    WEBHOOK_URL      = "https://${var.env}-n8n-${random_id.suffix.hex}.run.app"
    GENERIC_TIMEZONE = "UTC"
  }

  # Configuración de escalado
  min_instances = 0
  max_instances = 10
}

# Secret Manager - Gestión de secretos
module "secrets" {
  source = "git::https://github.com/diegokalpa/platform-root.git//infra-gcp/modules/secret-manager"
  
  project_id = var.project_id
  env        = var.env
  
  # Service account que usan los servicios de Cloud Run
  cloud_run_service_account = "dievops-dev@${var.project_id}.iam.gserviceaccount.com"
  
  # Definir los secretos que queremos crear
  secrets = {
    # Ejemplo: credenciales de base de datos
    "db-password" = {
      secret_data = "placeholder" # Se reemplazará manualmente en GCP
      allowed_service_accounts = [
        "dievops-dev@${var.project_id}.iam.gserviceaccount.com"
      ]
    }
    
    # Ejemplo: API key de un servicio externo
    "api-key" = {
      secret_data = "placeholder" # Se reemplazará manualmente en GCP
      allowed_service_accounts = [
        "dievops-dev@${var.project_id}.iam.gserviceaccount.com"
      ]
    }
    
    # Ejemplo: configuración de n8n
    "n8n-encryption-key" = {
      secret_data = "placeholder" # Se reemplazará manualmente en GCP
      allowed_service_accounts = [
        "dievops-dev@${var.project_id}.iam.gserviceaccount.com"
      ]
    }
  }
}

# Random ID para el webhook URL
resource "random_id" "suffix" {
  byte_length = 4
}

# Output útil para obtener la URL de n8n
output "n8n_url" {
  description = "URL donde n8n está desplegado"
  value       = module.n8n.service_url
}

# Outputs de Secret Manager
output "secret_ids" {
  description = "IDs de los secretos creados"
  value       = module.secrets.secret_ids
}

output "secret_versions" {
  description = "Versiones de los secretos creados"
  value       = module.secrets.secret_versions
}
