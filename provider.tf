provider "tfe" {
  hostname = var.tfc_hostname
}
provider "vault" {
  address = var.vault_url
  namespace = var.vault_namespace
}
