variable "konnect_token" {
  description = "Kong Konnect Personal Access Token"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.konnect_token) > 20
    error_message = "Konnect token must be a valid personal access token."
  }
}

variable "konnect_server_url" {
  description = "Kong Konnect server URL"
  type        = string
  default     = "https://au.api.konghq.com"

  validation {
    condition     = can(regex("^https://", var.konnect_server_url))
    error_message = "Server URL must be a valid HTTPS URL."
  }
}

variable "control_plane_name" {
  description = "Name of the existing Kong Konnect Control Plane"
  type        = string

  validation {
    condition     = length(var.control_plane_name) > 0
    error_message = "Control plane name cannot be empty."
  }
}

variable "portal_name" {
  description = "Name of the existing Kong Konnect Developer Portal"
  type        = string

  validation {
    condition     = length(var.portal_name) > 0
    error_message = "Portal name cannot be empty."
  }
}

variable "apis_config_file" {
  description = "Path to the APIs configuration YAML file"
  type        = string
  default     = "../config/apis.yaml"

  validation {
    condition     = can(regex("\\.ya?ml$", var.apis_config_file))
    error_message = "Config file must be a YAML file (.yaml or .yml)."
  }
}

variable "specs_directory" {
  description = "Directory containing OpenAPI specification files"
  type        = string
  default     = "../specs"
}

variable "enable_portal_pages" {
  description = "Whether to create portal pages from configuration"
  type        = bool
  default     = true
}

variable "default_rate_limit_minute" {
  description = "Default rate limit per minute"
  type        = number
  default     = 100

  validation {
    condition     = var.default_rate_limit_minute > 0
    error_message = "Rate limit must be a positive number."
  }
}

variable "default_rate_limit_hour" {
  description = "Default rate limit per hour"
  type        = number
  default     = 1000

  validation {
    condition     = var.default_rate_limit_hour > 0
    error_message = "Rate limit must be a positive number."
  }
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default = {
    managed_by = "terraform"
    project    = "kong-apiops"
    deployed_by = "github-actions"
  }
}
