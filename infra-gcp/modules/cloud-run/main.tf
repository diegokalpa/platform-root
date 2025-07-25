resource "google_cloud_run_v2_service" "service" {
  name     = "${var.env}-${var.service_name}"
  location = var.region
  project  = var.project_id

  template {
    containers {
      image = var.image

      resources {
        limits = {
          cpu    = var.cpu_limit
          memory = var.memory_limit
        }
      }

      ports {
        container_port = var.container_port
      }

      # Variables de entorno dinámicas
      dynamic "env" {
        for_each = var.environment_variables
        content {
          name  = env.key
          value = env.value
        }
      }

      # Variables de entorno secretas (opcional)
      dynamic "env" {
        for_each = var.secret_environment_variables
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = env.value.secret_name
              version = env.value.secret_version
            }
          }
        }
      }
    }

    # Configuración de escalado
    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }

    # Configuración de concurrencia
    execution_environment = var.execution_environment
  }

  # Configuración de tráfico
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

# IAM - Configuración de acceso
resource "google_cloud_run_service_iam_member" "public" {
  count    = var.public_access ? 1 : 0
  project  = var.project_id
  location = var.region
  service  = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# IAM - Acceso específico por servicio account (opcional)
resource "google_cloud_run_service_iam_member" "service_account" {
  for_each = toset(var.allowed_service_accounts)
  project  = var.project_id
  location = var.region
  service  = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${each.value}"
} 