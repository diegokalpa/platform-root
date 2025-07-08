resource "google_cloud_run_v2_service" "service" {
  name     = "${var.env}-${var.service_name}"
  location = var.region
  project  = var.project_id

  template {
    containers {
      image = var.image

      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }

      ports {
        container_port = 5678
      }

      env {
        name  = "ENVIRONMENT"
        value = var.env
      }

      env {
        name  = "N8N_HOST"
        value = "0.0.0.0"
      }

      env {
        name  = "N8N_PORT"
        value = "5678"
      }

      env {
        name  = "N8N_PROTOCOL"
        value = "https"
      }

      env {
        name  = "WEBHOOK_URL"
        value = "https://${var.env}-${var.service_name}-${random_id.suffix.hex}.run.app"
      }

      env {
        name  = "GENERIC_TIMEZONE"
        value = "UTC"
      }
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

# IAM - Hacer el servicio público
resource "google_cloud_run_service_iam_member" "public" {
  project  = var.project_id
  location = var.region
  service  = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
} 