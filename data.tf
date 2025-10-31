data "tfe_organization" "main" {
  name = var.organization
}

data "tfe_project" "main" {
  for_each     = setunion([var.target_tfc_project], var.additional_tfc_projects)
  name         = each.key
  organization = data.tfe_organization.main.name
}

locals {
  project_ids = toset([
    for p in data.tfe_project.main : p.id
  ])

  variables = {
    TFC_VAULT_ADDR = {
      key         = "TFC_VAULT_ADDR"
      value       = var.tfc_vault_addr
      description = "Vault Address Environment Variable"
      category    = "env"
    },
    TFC_VAULT_NAMESPACE = {
      key         = "TFC_VAULT_NAMESPACE"
      value       = var.tfc_vault_namespace
      description = "Vault Namespace Environment Variable"
      category    = "env"
    },
    TFC_VAULT_PROVIDER_AUTH = {
      key         = "TFC_VAULT_PROVIDER_AUTH"
      value       = "true"
      description = "Instruct Workspace/s to leverage the Vault Provider Auth method"
      category    = "env"
    },
    TFC_VAULT_RUN_ROLE = {
      key         = "TFC_VAULT_RUN_ROLE"
      value       = var.tfc_vault_run_role
      description = "Instruct the Workspace to leverage this Vault Role"
      category    = "env"
    },
  }

  role_policy = <<EOT
  # Allow a token to inspect its own metadata (TTL, policies, etc.) — read-only
    path "auth/token/lookup-self" {
    capabilities = ["read"]
  }

  # Allow a token to renew its own lease — update required to extend
    path "auth/token/renew-self" {
    capabilities = ["update"]
  }

  # Allow viewing ACL policy definitions but not modifying them
  # (remove "update" to prevent changing policies)
    path "sys/policies/acl/*" {
    capabilities = ["read", "list"]
  }

  # Allow viewing the JWT auth mount configuration and details.
  # Changes to mount settings are restricted to the dedicated config  path below.
    path "sys/mounts/auth/jwt" {
    capabilities = ["read"]
  }
    path "sys/mounts/auth/jwt/*" {
    capabilities = ["read"]
  }

  # Allow reading and updating JWT auth METHOD configuration (OIDC/JWT provider settings)
  # This is the minimal place to allow updates to the auth method itself.
    path "auth/jwt/config" {
    capabilities = ["read", "update"]
  }

  # Allow a token to revoke itself only (no ability to revoke others)
    path "auth/token/revoke-self" {
    capabilities = ["update"]
  }

  # Allow creating and updating JWT roles, and listing/reading them.
  # Removed "delete" to avoid accidental/unauthorized role removal.
    path "auth/jwt/role/*" {
    capabilities = ["create", "update", "read", "list"]
  }

  # Read-only access to secrets — no write/delete privileges.
    path "secret/*" {
    capabilities = ["read", "list"]
  }

  # Minimal namespace access: allow listing and reading namespace info but not create/delete/sudo.
  # If this token must create or manage namespaces, those   capabilities should be scoped to a separate admin policy.
    path "sys/namespaces/*" {
    capabilities = ["create", "update","read", "list"]
  }
    path "/+/sys/namespaces/*" {
    capabilities = ["create", "update", "read", "list"]
  }
EOT
}