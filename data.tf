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
      value       = "admin/terraform"
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
      value       = "vault-configuration-admin"
      description = "Instruct the Workspace to leverage this Vault Role"
      category    = "env"
    },
  }



  full_admin_policy = <<EOT
  path "*" {
  	capabilities = ["sudo","read","create","update","delete","list","patch"]
  }
  EOT

  vault_policy = <<EOT
########################################
# Self-management permissions
########################################

# Allow the token to view details about itself (e.g. TTL, policies, metadata)
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow the token to renew its own lease before expiry
path "auth/token/renew-self" {
  capabilities = ["update"]
}

# Allow the token to revoke itself and become invalid
path "auth/token/revoke-self" {
  capabilities = ["update"]
}


########################################
# ACL policy management
########################################

# Allow reading policies (no creation or deletion — prevents privilege escalation)
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "list", "delete"]
}

# Allow the same in a single child namespace
path "/+/sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "list", "delete"]
}


########################################
# JWT auth method management
########################################

# Allow managing JWT auth mount at current namespace (create + inspect + tune)
path "sys/mounts/auth/jwt" {
  capabilities = ["create", "read", "update", "list"]
}
path "sys/mounts/auth/jwt" {
  capabilities = ["create", "read", "update", "list"]
}
path "sys/mounts/auth/jwt/*" {
  capabilities = ["create", "read", "update", "list"]
}
path "sys/mounts/auth/jwt/*" {
  capabilities = ["create", "read", "update", "list"]
}

# Allow managing JWT auth mount one namespace down
path "/+/sys/mounts/auth/jwt" {
  capabilities = ["create", "read", "update", "list"]
}
path "/+/sys/mounts/auth/jwt/*" {
  capabilities = ["create", "read", "update", "list"]
}

# Retain legacy sys/auth endpoints (read-only for visibility)
path "sys/auth/jwt" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "/+/sys/auth/jwt" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Allow reading and updating JWT auth configuration
path "auth/jwt/config" {
  capabilities = ["read", "update"]
}

# Allow reading and updating JWT auth configuration one namespace down
path "/+/auth/jwt/config" {
  capabilities = ["read", "update"]
}

# Allow full lifecycle management of JWT roles (create + manage + list)
path "auth/jwt/role/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow full lifecycle management of JWT roles one namespace down
path "/+/auth/jwt/role/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}


########################################
# Secrets engine access
########################################

# Allow read-only access to secrets under "secret/"
path "secret/*" {
  capabilities = ["read"]
}


########################################
# Namespace management
########################################

# Restrict namespace management to read-only — prevent accidental deletion
path "sys/namespaces/*" {
  capabilities = ["create", "read", "update", "list", "delete"]
}

# Allow creation of *one* child namespace (needed for JWT one level down)
path "/+/sys/namespaces/*" {
  capabilities = ["create", "read", "update", "list", "delete"]
}

# Allow read-only visibility two levels down
path "/+/+/sys/namespaces/*" {
  capabilities = ["create", "read", "update", "list", "delete"]
}
EOT


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
# Changes to mount settings are restricted to the dedicated config path below.
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

# Allow management of Namespaces and Child Namespaces 
path "sys/namespaces/*" {
  capabilities = ["create", "update","read", "list"]
}
path "/+/sys/namespaces/*" {
  capabilities = ["create", "update", "read", "list"]
}
EOT
}
