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
