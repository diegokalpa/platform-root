# Secret Manager - Crear secretos
resource "google_secret_manager_secret" "secret" {
  for_each  = var.secrets
  secret_id = "${var.env}-${each.key}"
  project   = var.project_id

  replication {
    auto {}
  }

  labels = merge(var.common_labels, {
    environment = var.env
    secret_name = each.key
  })
}

# Secret Manager - Versiones de secretos (vacías para llenar manualmente)
resource "google_secret_manager_secret_version" "secret_version" {
  for_each = var.secrets
  secret   = google_secret_manager_secret.secret[each.key].id
  secret_data = "placeholder" # Valor temporal, se reemplazará manualmente

  lifecycle {
    ignore_changes = [
      secret_data
    ]
  }
}

# IAM - Acceso para Cloud Run services
resource "google_secret_manager_secret_iam_member" "cloud_run_access" {
  for_each = var.secrets
  project  = var.project_id
  secret_id = google_secret_manager_secret.secret[each.key].secret_id
  role     = "roles/secretmanager.secretAccessor"
  member   = "serviceAccount:${var.cloud_run_service_account}"
}

# IAM - Acceso para service accounts específicos
resource "google_secret_manager_secret_iam_member" "service_account_access" {
  for_each = {
    for pair in flatten([
      for secret_key, secret_config in var.secrets : [
        for sa in secret_config.allowed_service_accounts : {
          secret_key = secret_key
          service_account = sa
        }
      ]
    ]) : "${pair.secret_key}-${pair.service_account}" => pair
  }

  project   = var.project_id
  secret_id = google_secret_manager_secret.secret[each.value.secret_key].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${each.value.service_account}"
} 