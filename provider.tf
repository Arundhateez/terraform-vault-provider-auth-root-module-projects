provider "tfe" {
  hostname = var.tfc_hostname
}
provider "vault" {
  address   = var.vault_url
  namespace = var.vault_namespace
}


terraform {
  cloud {
    organization = "LegalGeneral-OneTech"
    workspaces {
      name    = "hcp_workspace_vault_provider_auth_cloud-security-non-production"
      project = "workspace-management-vault"
    }
  }
  required_providers {
    tfe = {
      version = "~> 0.70.0"
      source  = "hashicorp/tfe"
    }
    vault = {
      version = "~> 5.3.0"
      source  = "hashicorp/vault"
    }
  }
}
