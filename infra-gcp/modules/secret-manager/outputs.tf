output "secret_ids" {
  description = "Map of secret IDs created"
  value = {
    for key, secret in google_secret_manager_secret.secret : key => secret.secret_id
  }
}

output "secret_versions" {
  description = "Map of secret versions created"
  value = {
    for key, version in google_secret_manager_secret_version.secret_version : key => version.version
  }
}

output "secret_names" {
  description = "Map of secret names created"
  value = {
    for key, secret in google_secret_manager_secret.secret : key => secret.name
  }
} 