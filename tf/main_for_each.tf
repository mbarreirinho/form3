# ########################################
# # Vault Audit
# ########################################

# resource "vault_audit" "audit_dev" {
#   provider = vault.vault_dev
#   type     = "file"

#   options = {
#     file_path = "/vault/logs/audit_dev.log"
#   }
# }

# resource "vault_audit" "audit_stg" {
#   provider = vault.vault_stg
#   type     = "file"

#   options = {
#     file_path = "/vault/logs/audit_stg.log"
#   }
# }

# resource "vault_audit" "audit_prod" {
#   provider = vault.vault_prod
#   type     = "file"

#   options = {
#     file_path = "/vault/logs/audit_prod.log"
#   }
# }

# ########################################
# # Vault Auth Backends
# ########################################

# resource "vault_auth_backend" "userpass_dev" {
#   provider = vault.vault_dev
#   type     = "userpass"
# }

# resource "vault_auth_backend" "userpass_stg" {
#   provider = vault.vault_stg
#   type     = "userpass"
# }

# resource "vault_auth_backend" "userpass_prod" {
#   provider = vault.vault_prod
#   type     = "userpass"
# }

# ########################################
# # Vault Generic Secrets
# ########################################

# resource "vault_generic_secret" "secrets_dev" {
#   for_each = { for combo in local.service_env_matrix : combo.service => combo if combo.env_code == "dev" && combo.service != "frontend" }

#   provider = vault.vault_dev
#   path     = "secret/${each.value.env_name}/${each.value.service}"

#   data_json = jsonencode({
#     db_user     = each.value.service
#     db_password = "auto-${each.value.service}-dev"
#   })
# }

# resource "vault_generic_secret" "secrets_stg" {
#   for_each = { for combo in local.service_env_matrix : combo.service => combo if combo.env_code == "stg" && combo.service != "frontend" }

#   provider = vault.vault_stg
#   path     = "secret/${each.value.env_name}/${each.value.service}"

#   data_json = jsonencode({
#     db_user     = each.value.service
#     db_password = "auto-${each.value.service}-stg"
#   })
# }

# resource "vault_generic_secret" "secrets_prod" {
#   for_each = { for combo in local.service_env_matrix : combo.service => combo if combo.env_code == "prod" && combo.service != "frontend" }

#   provider = vault.vault_prod
#   path     = "secret/${each.value.env_name}/${each.value.service}"

#   data_json = jsonencode({
#     db_user     = each.value.service
#     db_password = "auto-${each.value.service}-prod"
#   })
# }

# ########################################
# # Vault Policies
# ########################################

# resource "vault_policy" "policy_dev" {
#   for_each = vault_generic_secret.secrets_dev

#   provider = vault.vault_dev
#   name     = "${each.key}-development"

#   policy = <<EOT
# path "secret/data/development/${each.key}" {
#   capabilities = ["list", "read"]
# }
# EOT
# }

# resource "vault_policy" "policy_stg" {
#   for_each = vault_generic_secret.secrets_stg

#   provider = vault.vault_stg
#   name     = "${each.key}-staging"

#   policy = <<EOT
# path "secret/data/staging/${each.key}" {
#   capabilities = ["list", "read"]
# }
# EOT
# }

# resource "vault_policy" "policy_prod" {
#   for_each = vault_generic_secret.secrets_prod

#   provider = vault.vault_prod
#   name     = "${each.key}-production"

#   policy = <<EOT
# path "secret/data/production/${each.key}" {
#   capabilities = ["list", "read"]
# }
# EOT
# }

# ########################################
# # Vault Generic Endpoints (Userpass Users)
# ########################################

# resource "vault_generic_endpoint" "users_dev" {
#   for_each = vault_policy.policy_dev

#   provider             = vault.vault_dev
#   depends_on           = [vault_auth_backend.userpass_dev]
#   path                 = "auth/userpass/users/${each.key}-development"
#   ignore_absent_fields = true

#   data_json = jsonencode({
#     policies = ["${each.key}-development"]
#     password = "123-${each.key}-dev"
#   })
# }

# resource "vault_generic_endpoint" "users_stg" {
#   for_each = vault_policy.policy_stg

#   provider             = vault.vault_stg
#   depends_on           = [vault_auth_backend.userpass_stg]
#   path                 = "auth/userpass/users/${each.key}-staging"
#   ignore_absent_fields = true

#   data_json = jsonencode({
#     policies = ["${each.key}-staging"]
#     password = "123-${each.key}-stg"
#   })
# }

# resource "vault_generic_endpoint" "users_prod" {
#   for_each = vault_policy.policy_prod

#   provider             = vault.vault_prod
#   depends_on           = [vault_auth_backend.userpass_prod]
#   path                 = "auth/userpass/users/${each.key}-production"
#   ignore_absent_fields = true

#   data_json = jsonencode({
#     policies = ["${each.key}-production"]
#     password = "123-${each.key}-prod"
#   })
# }

# ########################################
# # Docker Containers
# ########################################

# resource "docker_container" "containers_dev" {
#   for_each = { for combo in local.service_env_matrix : combo.service => combo if combo.env_code == "dev" }

#   image = each.value.image
#   name  = "${each.value.service}_development"

#   env = compact([
#     "VAULT_ADDR=${each.value.vault_addr}",
#     each.value.service != "frontend" ? "VAULT_USERNAME=${each.value.service}-development" : null,
#     each.value.service != "frontend" ? "VAULT_PASSWORD=123-${each.value.service}-dev" : null,
#     "ENVIRONMENT=development"
#   ])

#   networks_advanced {
#     name = each.value.network
#   }

#   dynamic "ports" {
#     for_each = each.value.service == "frontend" ? [1] : []
#     content {
#       internal = 80
#       external = each.value.external_port
#     }
#   }

#   lifecycle {
#     ignore_changes = all
#   }

#   depends_on = [vault_generic_endpoint.users_dev]
# }

# resource "docker_container" "containers_stg" {
#   for_each = { for combo in local.service_env_matrix : combo.service => combo if combo.env_code == "stg" }

#   image = each.value.image
#   name  = "${each.value.service}_staging"

#   env = compact([
#     "VAULT_ADDR=${each.value.vault_addr}",
#     each.value.service != "frontend" ? "VAULT_USERNAME=${each.value.service}-staging" : null,
#     each.value.service != "frontend" ? "VAULT_PASSWORD=123-${each.value.service}-stg" : null,
#     "ENVIRONMENT=staging"
#   ])

#   networks_advanced {
#     name = each.value.network
#   }

#   dynamic "ports" {
#     for_each = each.value.service == "frontend" ? [1] : []
#     content {
#       internal = 80
#       external = each.value.external_port
#     }
#   }

#   lifecycle {
#     ignore_changes = all
#   }

#   depends_on = [vault_generic_endpoint.users_stg]
# }

# resource "docker_container" "containers_prod" {
#   for_each = { for combo in local.service_env_matrix : combo.service => combo if combo.env_code == "prod" }

#   image = each.value.image
#   name  = "${each.value.service}_production"

#   env = compact([
#     "VAULT_ADDR=${each.value.vault_addr}",
#     each.value.service != "frontend" ? "VAULT_USERNAME=${each.value.service}-production" : null,
#     each.value.service != "frontend" ? "VAULT_PASSWORD=123-${each.value.service}-prod" : null,
#     "ENVIRONMENT=production"
#   ])

#   networks_advanced {
#     name = each.value.network
#   }

#   dynamic "ports" {
#     for_each = each.value.service == "frontend" ? [1] : []
#     content {
#       internal = 80
#       external = each.value.external_port
#     }
#   }

#   lifecycle {
#     ignore_changes = all
#   }

#   depends_on = [vault_generic_endpoint.users_prod]
# }
