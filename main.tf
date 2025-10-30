module "vault-auth" {
  source  = "github.com/sce81/Terraform-Vault-Provider-Auth"


  jwt_backend_path      = var.jwt_backend_path
  role_name             = var.role_name
  tfc_organization_name = data.tfe_organization.main.name
  vault_policy          = local.role_policy
  target_tfc_project    = var.target_tfc_project
  vault_url             = "https://vault-cluster-public-vault-485f7257.cbb919d0.z1.hashicorp.cloud:8200/"
}


//module "vault-variables" {
//  source = "/Users/simon.elliott/Documents/Code/New_Structure/Terraform_Modules/TFE/terraform-tfe-variable-sets"
//
//}
