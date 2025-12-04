
#
# Defining Network Variables
#

variable "http_port" {
  description = "HTTP Port for Frontend"
  type        = number
  default     = 80
}


#
# Defining Secrets Variables
#

variable "db_user_account_stg" {
  type        = string
  description = "DB user for account stg"
  sensitive   = true
}

variable "db_password_account_stg" {
  type        = string
  description = "DB password for account stg"
  sensitive   = true
  default = ""
}

variable "vault_generic_endpoint_password_staging" {
  type        = string
  description = "Vault generic endpoint password for stg"
  sensitive   = true
  default = ""

}

variable "vault_generic_secret_gateway_staging" {
  type        = string
  description = "Vault generic gateway secret for stg"
  sensitive   = true
  default = ""

}

variable "vault_generic_db_user_gateway_staging" {
  type        = string
  description = "Vault generic gateway db_user for stg"
  sensitive   = true
  default = ""

}

variable "vault_generic_endpoint_password_gateway_staging" {
  type        = string
  description = "Vault generic endpoint passwoed gateway stg"
  sensitive   = true
  default = ""

}



variable "vault_generic_db_user_payment_staging" {
  type        = string
  description = "Vault generic payment db_user stg"
  sensitive   = true
  default = ""

}


variable "vault_generic_db_password_payment_staging" {
  type        = string
  description = "Vault generic payment db_passwoed stg"
  sensitive   = true
  default = ""

}