variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "secrets" {
  description = "Map of secrets to create"
  type = map(object({
    secret_data              = string
    allowed_service_accounts = list(string)
  }))
  default = {}
}

variable "cloud_run_service_account" {
  description = "Service account used by Cloud Run services"
  type        = string
  default     = ""
}

variable "common_labels" {
  description = "Common labels to apply to all secrets"
  type        = map(string)
  default = {
    managed_by = "terraform"
    module     = "secret-manager"
  }
} 