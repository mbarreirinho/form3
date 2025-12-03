
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
  description = "Usuário do Vault"
  sensitive   = true
}