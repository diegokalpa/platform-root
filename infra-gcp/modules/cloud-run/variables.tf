variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
}

variable "image" {
  description = "Container image to deploy"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8080
}

variable "cpu_limit" {
  description = "CPU limit for the container"
  type        = string
  default     = "1000m"
}

variable "memory_limit" {
  description = "Memory limit for the container"
  type        = string
  default     = "512Mi"
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "secret_environment_variables" {
  description = "Secret environment variables for the container"
  type = map(object({
    secret_name    = string
    secret_version = string
  }))
  default = {}
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 100
}

variable "execution_environment" {
  description = "Execution environment (GEN1 or GEN2)"
  type        = string
  default     = "GEN2"
  validation {
    condition     = contains(["GEN1", "GEN2"], var.execution_environment)
    error_message = "Execution environment must be either GEN1 or GEN2."
  }
}

variable "public_access" {
  description = "Whether to make the service publicly accessible"
  type        = bool
  default     = true
}

variable "allowed_service_accounts" {
  description = "List of service accounts allowed to invoke the service"
  type        = list(string)
  default     = []
} 