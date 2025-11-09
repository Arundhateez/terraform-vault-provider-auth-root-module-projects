module "vault-auth" {
  source = "app.terraform.io/HashiCorp_AWS_Org/vault-provider-auth-roles/vault"
  jwt_backend_path      = var.jwt_backend_path
  role_name             = var.vault_role_name
  tfc_organization_name = data.tfe_organization.main.name
  vault_policy          = local.vault_policy
  target_tfc_project    = var.target_tfc_project
}


module "vault-variables" {
  source = "app.terraform.io/HashiCorp_AWS_Org/tfe-variable-sets/tfe"

  var_set_variables     = local.variables
  set_name              = "Vault Auth: ${var.target_tfc_project}"
  set_description       = "HCP Vault Auth VarSet for Terraform Project: ${var.target_tfc_project}"
  tfc_organization_name = data.tfe_organization.main.name
  tfc_project           = local.project_ids
}
