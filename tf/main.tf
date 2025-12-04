#
######################################
#  Block for Dev resources
######################################
#


resource "vault_audit" "audit_dev" {
  provider = vault.vault_dev
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_auth_backend" "userpass_dev" {
  provider = vault.vault_dev
  type     = "userpass"
}

resource "vault_generic_secret" "account_development" {
  provider = vault.vault_dev
  path     = "secret/development/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "965d3c27-9e20-4d41-91c9-61e6631870e7"
}
EOT
}

resource "vault_policy" "account_development" {
  provider = vault.vault_dev
  name     = "account-development"

  policy = <<EOT

path "secret/data/development/account" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "account_development" {
  provider             = vault.vault_dev
  depends_on           = [vault_auth_backend.userpass_dev]
  path                 = "auth/userpass/users/account-development"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["account-development"],
  "password": "123-account-development"
}
EOT
}

resource "vault_generic_secret" "gateway_development" {
  provider = vault.vault_dev
  path     = "secret/development/gateway"

  data_json = <<EOT
{
  "db_user":   "gateway",
  "db_password": "10350819-4802-47ac-9476-6fa781e35cfd"
}
EOT
}

resource "vault_policy" "gateway_development" {
  provider = vault.vault_dev
  name     = "gateway-development"

  policy = <<EOT

path "secret/data/development/gateway" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "gateway_development" {
  provider             = vault.vault_dev
  depends_on           = [vault_auth_backend.userpass_dev]
  path                 = "auth/userpass/users/gateway-development"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["gateway-development"],
  "password": "123-gateway-development"
}
EOT
}
resource "vault_generic_secret" "payment_development" {
  provider = vault.vault_dev
  path     = "secret/development/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "a63e8938-6d49-49ea-905d-e03a683059e7"
}
EOT
}

resource "vault_policy" "payment_development" {
  provider = vault.vault_dev
  name     = "payment-development"

  policy = <<EOT

path "secret/data/development/payment" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "payment_development" {
  provider             = vault.vault_dev
  depends_on           = [vault_auth_backend.userpass_dev]
  path                 = "auth/userpass/users/payment-development"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["payment-development"],
  "password": "123-payment-development"
}
EOT
}

resource "docker_container" "account_development" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=account-development",
    "VAULT_PASSWORD=123-account-development",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }

  depends_on = [vault_generic_endpoint.account_development]
}

resource "docker_container" "gateway_development" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=gateway-development",
    "VAULT_PASSWORD=123-gateway-development",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }

  depends_on = [vault_generic_endpoint.gateway_development]
}

resource "docker_container" "payment_development" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=payment-development",
    "VAULT_PASSWORD=123-payment-development",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }

  depends_on = [vault_generic_endpoint.payment_development]
}

resource "docker_container" "frontend_development" {
  image = "docker.io/nginx:latest"
  name  = "frontend_development"

  ports {
    internal = var.http_port
    external = 4080
  }

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}


#
######################################
#  Block for Staging resources
######################################
#



resource "vault_audit" "audit_stg" {
  provider = vault.vault_stg
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}


resource "vault_auth_backend" "userpass_stg" {
  provider = vault.vault_stg
  type     = "userpass"
}


resource "vault_generic_secret" "account_staging" {
  provider = vault.vault_stg
  path     = "secret/staging/account"

  data_json = jsonencode({

  "db_user":   "${var.db_user_account_stg}",
  "db_password": "${var.db_password_account_stg}"
  })
  
}



resource "vault_policy" "account_staging" {
  provider = vault.vault_stg
  name     = "account-staging"

  policy = jsonencode({

    path   = { 
      "secret/data/staging/account" = {
        capabilities = ["list", "read"]
      }
    }

})

}

resource "vault_generic_endpoint" "account_staging" {
  provider             = vault.vault_stg
  depends_on           = [vault_auth_backend.userpass_stg]
  path                 = "auth/userpass/users/account-staging"
  ignore_absent_fields = true

  data_json = jsonencode({

  "policies": ["account-staging"],
  "password": "${var.vault_generic_endpoint_password_staging}"
  })

}

resource "vault_generic_secret" "gateway_staging" {
  provider = vault.vault_stg
  path     = "secret/staging/gateway"

  data_json = jsonencode({

  "db_user":   "${var.vault_generic_db_user_gateway_staging}",
  "db_password": "${var.vault_generic_secret_gateway_staging}"
})

}

resource "vault_policy" "gateway_staging" {
  provider = vault.vault_stg
  name     = "gateway-staging"

  policy = <<EOT

path "secret/data/staging/gateway" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "gateway_staging" {
  provider             = vault.vault_stg
  depends_on           = [vault_auth_backend.userpass_stg]
  path                 = "auth/userpass/users/gateway-staging"
  ignore_absent_fields = true

  data_json = jsonencode({

  "policies": ["gateway-staging"],
  "password": "${var.vault_generic_endpoint_password_gateway_staging}"
  })

}

resource "vault_generic_secret" "payment_staging" {
  provider = vault.vault_stg
  path     = "secret/staging/payment"

  data_json = jsonencode({

  "db_user":   "${var.vault_generic_db_user_payment_staging}",
  "db_password": "${var.vault_generic_db_password_payment_staging}"
  })

}

resource "vault_policy" "payment_staging" {
  provider = vault.vault_stg
  name     = "payment-staging"

  policy = <<EOT

path "secret/data/staging/payment" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "payment_staging" {
  provider             = vault.vault_stg
  depends_on           = [vault_auth_backend.userpass_stg]
  path                 = "auth/userpass/users/payment-staging"
  ignore_absent_fields = true

  data_json = jsonencode({

  "policies": ["payment-staging"],
  "password": "${var.vault_generic_endpoint_password_payment_staging}"
  })

}


#
# Resource for container creation
#

resource "docker_container" "account_staging" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_staging"

  env = [
    "VAULT_ADDR=http://vault-staging:8200",
    "VAULT_USERNAME=${var.vault_account_username_staging}",
    "VAULT_PASSWORD=${var.vault_account_password_staging}",
    "ENVIRONMENT=staging"
  ]

  networks_advanced {
    name = "vagrant_staging"
  }

  lifecycle {
    ignore_changes = all
  }

  depends_on = [vault_generic_endpoint.account_staging]
}

## PS: I tryed creatre variables for the following authentication but i encounter erros
# Iĺl care about it late

resource "docker_container" "gateway_staging" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_staging"

  env = [
    "VAULT_ADDR=http://vault-staging:8200",
    "VAULT_USERNAME=gateway-staging",
    "VAULT_PASSWORD=123-gateway-staging",
    "ENVIRONMENT=staging"
  ]

  networks_advanced {
    name = "vagrant_staging"
  }

  lifecycle {
    ignore_changes = all
  }

  depends_on = [vault_generic_endpoint.gateway_staging]
}

resource "docker_container" "payment_staging" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_staging"

  env = [
    "VAULT_ADDR=http://vault-staging:8200",
    "VAULT_USERNAME=payment-staging",
    "VAULT_PASSWORD=123-payment-staging",
    "ENVIRONMENT=staging"
  ]

  networks_advanced {
    name = "vagrant_staging"
  }

  lifecycle {
    ignore_changes = all
  }

  depends_on = [vault_generic_endpoint.payment_staging]
}


resource "docker_container" "frontend_staging" {
  image = "docker.io/nginx:latest"
  name  = "frontend_staging"

  ports {
    internal = var.http_port
    external = 4082
  }

  networks_advanced {
    name = "vagrant_staging"
  }

  lifecycle {
    ignore_changes = all
  }
}




#
######################################
#  Block for Prod resources
######################################
#


resource "vault_audit" "audit_prod" {
  provider = vault.vault_prod
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}


resource "vault_auth_backend" "userpass_prod" {
  provider = vault.vault_prod
  type     = "userpass"
}


resource "vault_generic_secret" "account_production" {
  provider = vault.vault_prod
  path     = "secret/production/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "${var.db_password_account_stg}"
}
EOT
}

resource "vault_policy" "account_production" {
  provider = vault.vault_prod
  name     = "account-production"

  policy = <<EOT

path "secret/data/production/account" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "account_production" {
  provider             = vault.vault_prod
  depends_on           = [vault_auth_backend.userpass_prod]
  path                 = "auth/userpass/users/account-production"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["account-production"],
  "password": "123-account-production"
}
EOT
}

resource "vault_generic_secret" "gateway_production" {
  provider = vault.vault_prod
  path     = "secret/production/gateway"

  data_json = <<EOT
{
  "db_user":   "gateway",
  "db_password": "33fc0cc8-b0e3-4c06-8cf6-c7dce2705329"
}
EOT
}

resource "vault_policy" "gateway_production" {
  provider = vault.vault_prod
  name     = "gateway-production"

  policy = <<EOT

path "secret/data/production/gateway" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "gateway_production" {
  provider             = vault.vault_prod
  depends_on           = [vault_auth_backend.userpass_prod]
  path                 = "auth/userpass/users/gateway-production"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["gateway-production"],
  "password": "123-gateway-production"
}
EOT
}

resource "vault_generic_secret" "payment_production" {
  provider = vault.vault_prod
  path     = "secret/production/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "821462d7-47fb-402c-a22a-a58867602e39"
}
EOT
}

resource "vault_policy" "payment_production" {
  provider = vault.vault_prod
  name     = "payment-production"

  policy = <<EOT

path "secret/data/production/payment" {
    capabilities = ["list", "read"]
}

EOT
}

resource "vault_generic_endpoint" "payment_production" {
  provider             = vault.vault_prod
  depends_on           = [vault_auth_backend.userpass_prod]
  path                 = "auth/userpass/users/payment-production"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["payment-production"],
  "password": "123-payment-production"
}
EOT
}


#
# Resource for container creation
#
resource "docker_container" "account_production" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_production"

  env = [
    "VAULT_ADDR=http://vault-production:8200",
    "VAULT_USERNAME=account-production",
    "VAULT_PASSWORD=123-account-production",
    "ENVIRONMENT=production"
  ]

  networks_advanced {
    name = "vagrant_production"
  }

  lifecycle {
    ignore_changes = all
  }

  depends_on = [vault_generic_endpoint.account_production]
}

resource "docker_container" "gateway_production" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_production"

  env = [
    "VAULT_ADDR=http://vault-production:8200",
    "VAULT_USERNAME=gateway-production",
    "VAULT_PASSWORD=123-gateway-production",
    "ENVIRONMENT=production"
  ]

  networks_advanced {
    name = "vagrant_production"
  }

  lifecycle {
    ignore_changes = all
  }

  depends_on = [vault_generic_endpoint.gateway_production]
}

resource "docker_container" "payment_production" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_production"

  env = [
    "VAULT_ADDR=http://vault-production:8200",
    "VAULT_USERNAME=payment-production",
    "VAULT_PASSWORD=123-payment-production",
    "ENVIRONMENT=production"
  ]

  networks_advanced {
    name = "vagrant_production"
  }

  lifecycle {
    ignore_changes = all
  }

  depends_on = [vault_generic_endpoint.payment_production]
}

resource "docker_container" "frontend_production" {
  image = "docker.io/nginx:1.22.0-alpine"
  name  = "frontend_production"

  ports {
    internal = var.http_port
    external = 4081
  }

  networks_advanced {
    name = "vagrant_production"
  }

  lifecycle {
    ignore_changes = all
  }

}