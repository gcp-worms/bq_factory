# variable "gcp_project" {
#   description = "GCP project (id)"
#   type        = string
# }

# variable "gcp_region" {
#   description = "GCP region"
#   type        = string
# }

# variable "gcp_zone" {
#   description = "GCP zone"
#   type        = string
# }

# variable "env" {
#   description = "Environment"
#   type        = string
# }

# variable "zone" {
#   type        = string
#   description = "GCP Zone"
# }

variable "project_name" {
  type        = string
  description = "Name of the GCP project to be created"
}

variable "billing_account" {
  type        = string
  description = "Billing Account ID"
}

variable "organization_account" {
  type        = string
  description = "Organization Account ID"
}

variable "activated_apis" {
  type        = list(string)
  description = "APIs to be activated when creating the Project"
}

variable "data_dir" {
  description = "Relative path for the folder storing configuration data."
  type        = string
}
