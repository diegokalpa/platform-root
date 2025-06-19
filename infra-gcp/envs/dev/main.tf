provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  default     = "dievops-dev"
}

variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "us-central1"
}

# Output to verify TFC connection
output "project_info" {
  description = "Project information to verify TFC connection"
  value = {
    project_id = var.project_id
    region     = var.region
  }
}
