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
