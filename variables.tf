variable "vault_url" {
    type = string
    description = "URL relating to Vault"
}
variable "jwt_backend_path" {
    type = string
    default = "vault-auth"
    description = "the path in which you would like to mount the Vault JWT Auth Backend in Vault"
}
variable "tfc_vault_audience" {
    type = string
    default = "vault.workload.identity"
    description = "The audience value to use in run identity tokens"
}
variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with Vault"
}
variable "tfc_organization_name" {
    type = string
    description = "The name of your Terraform Cloud organization"
}
variable "tfc_project_name" {
    type = string
    default = "Vault-Auth"
    description = "The project under which a workspace will be created"
}
variable "tfc_workspace_name" {
    type = string
    default = "Vault-Provider-Auth"
    description = "The name of the workspace that you'd like to create and connect to Vault"
}
variable "vault_policy" {
    type = string
    default = null
    description = "Vault Policy to assiciate with Terraform Platform"
}