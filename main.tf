module "vault-auth" {
  source  = "github.com/sce81/Terraform-Vault-Provider-Auth"
  version = "1.0.0"

  vault_url             = var.vault_url
  jwt_backend_path      = var.jwt_backend_path
  tfc_vault_audience    = var.tfc_vault_audience
  tfc_organization_name = var.tfc_organization_name
  tfc_project_name      = var.tfc_project_name
  tfc_workspace_name    = var.tfc_workspace_name
  vault_policy          = local.vault_policy
}