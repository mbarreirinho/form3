
#
# Defining Network Variables
#

variable "http_port" {
  description = "HTTP Port for Frontend"
  type        = number
  default     = 80
}


######################################################
# Defining Secrets Variables for Staging Environment #
######################################################

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
  description = "Vault generic endpoint password gateway stg"
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


variable "vault_generic_endpoint_password_payment_staging" {
  type        = string
  description = "Vault generic endpoint password payment stg"
  sensitive   = true
  default = ""

}


# Vault Staging Auntentication

# variable "vault_generic_db_password_payment_staging" {
#   type        = string
#   description = "Vault generic payment db_passwoed stg"
#   sensitive   = true
#   default = ""

# }


# variable "vault_generic_endpoint_password_payment_staging" {
#   type        = string
#   description = "Vault generic endpoint password payment stg"
#   sensitive   = true
#   default = ""

# }

variable "vault_account_username_staging" {
  type        = string
  description = "Vault authentication username stg"
  sensitive   = true
  default = ""

}


variable "vault_account_password_staging" {
  type        = string
  description = "Vault authentication password stg"
  sensitive   = true
  default = ""

}

# Vault gateway Auhtntication
variable "vault_gateway_username_staging" {
  type        = string
  description = "Vault authentication username stg"
  sensitive   = true
  default = ""

}


variable "vault_gateway_password_staging" {
  type        = string
  description = "Vault authentication password stg"
  sensitive   = true
  default = ""

}


# Vault payment Auhtntication
variable "vault_payment_username_staging" {
  type        = string
  description = "Vault authentication username stg"
  sensitive   = true
  default = ""

}


variable "vault_payment_password_staging" {
  type        = string
  description = "Vault authentication password stg"
  sensitive   = true
  default = ""

}