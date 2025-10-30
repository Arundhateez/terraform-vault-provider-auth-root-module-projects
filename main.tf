module "vault-auth" {
  source  = "git@github.com:sce81/terraform-vault-provider-auth-roles.git"


  jwt_backend_path      = var.jwt_backend_path
  role_name             = var.vault_role_name
  tfc_organization_name = data.tfe_organization.main.name
  vault_policy          = local.role_policy
  target_tfc_project    = var.target_tfc_project
}


//module "vault-variables" {
//  source = "/Users/simon.elliott/Documents/Code/New_Structure/Terraform_Modules/TFE/terraform-tfe-variable-sets"
//
//}
