variable "vault_url" {
  type        = string
  description = "URL relating to Vault"
  default     = null
}
variable "jwt_backend_path" {
  type        = string
  default     = "jwt"
  description = "the path in which you would like to mount the Vault JWT Auth Backend in Vault"
}
variable "tfc_vault_audience" {
  type        = string
  default     = "vault.workload.identity"
  description = "The audience value to use in run identity tokens"
}
variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with Vault"
}
variable "organization" {
  type        = string
  default     = "HashiCorp_TFC_Automation_Demo"
  description = "The name of your Terraform Cloud organization"
}
variable "tfc_project_name" {
  type        = string
  default     = "Vault-Auth"
  description = "The project under which a workspace will be created"
}
variable "tfc_workspace_name" {
  type        = string
  default     = "Vault-Provider-Auth"
  description = "The name of the workspace that you'd like to create and connect to Vault"
}
variable "vault_policy" {
  type        = string
  default     = null
  description = "Vault Policy to assiciate with Terraform Platform"
}
variable "vault_namespace" {
  type        = string
  default     = "admin"
  description = "Vault Namespace to create integration"
}
variable "vault_role_name" {
  type        = string
  default     = "changeme"
  description = "Vault Role to assiciate with Terraform Platform"
}
variable "target_tfc_project" {
  type        = string
  default     = "changeme"
  description = "Target project to associate Varset with"
}
variable "additional_tfc_projects" {
  type        = set(string)
  default     = []
  description = "Additional Projects to associate Varset with"
}

variable "set_variables" {
  type        = map(string)
  default     = {}
  description = "Target project to associate Varset with"
}

variable "set_name" {
  type        = string
  default     = "changeme"
  description = "Target project to associate Varset with"
}
variable "set_description" {
  type        = string
  default     = "changeme"
  description = "Additional Projects to associate Varset with"
}

variable "tfc_vault_addr" {
  type        = string
  default     = "changeme"
  description = "Target project to associate Varset with"
}
variable "tfc_vault_namespace" {
  type        = string
  default     = "changeme"
  description = "Additional Projects to associate Varset with"
}
variable "tfc_vault_run_role" {
  type        = string
  default     = "changeme"
  description = "Additional Projects to associate Varset with"
}

