variable "env" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}
