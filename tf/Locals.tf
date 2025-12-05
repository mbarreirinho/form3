########################################
# Locals - ambientes e serviços
########################################

locals {
  environments = {
    dev = {
      name         = "development"
      vault_addr   = "http://vault-development:8200"
      provider_key = "vault_dev"
      network_name = "vagrant_development"
      port         = 4080
    }
    stg = {
      name         = "staging"
      vault_addr   = "http://vault-staging:8200"
      provider_key = "vault_stg"
      network_name = "vagrant_staging"
      port         = 4085
    }
    prod = {
      name         = "production"
      vault_addr   = "http://vault-production:8200"
      provider_key = "vault_prod"
      network_name = "vagrant_production"
      port         = 4081
    }
  }

  services = {
    account  = { image = "form3tech-oss/platformtest-account" }
    gateway  = { image = "form3tech-oss/platformtest-gateway" }
    payment  = { image = "form3tech-oss/platformtest-payment" }
    frontend = { image = "docker.io/nginx:1.22.0-alpine" }
  }

  # Criação da matriz service x environment
  service_env_matrix = flatten([
    for env_code, env in local.environments : [
      for service_name, service in local.services : {
        env_code      = env_code
        env_name      = env.name
        service       = service_name
        image         = service.image
        vault_addr    = env.vault_addr
        network       = env.network_name
        external_port = env.port
        provider_alias = env.provider_key
      }
    ]
  ])
}

