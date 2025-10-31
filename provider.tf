provider "tfe" {
  hostname = var.tfc_hostname
}
provider "vault" {
  address   = var.vault_url
  namespace = var.vault_namespace
}


terraform {
  cloud {
    organization = "HashiCorp_TFC_Automation_Demo"
    workspaces {
      tags = ["env"]
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
