
variable "charge_code" {
  description = "The code for applying charge code billing logic to the resources"
  type        = string
  default     = ""
}

variable "key_type" {
  description = "Indicate which kind of key to create: 'service' for key used by services; 'direct' for other keys. Must provide service_key or direct_key maps depending on the type"
  type        = string
  validation {
    condition     = can(regex("service|direct", var.key_type))
    error_message = "ERROR: Invalid Key type. Only the following values are valid: service, direct."
  }
}

variable "description" {
  description = "The description to give to the key"
  type        = string
}

variable "alias_name" {
  description = "Name for the kms key alias. A random string will be appended depending on the 'append_random_suffix' variable"
  type        = string
}

variable "append_random_suffix" {
  description = "Append a random string to the alias name. Default: true (yes)"
  type        = bool
  default     = true
}

variable "deletion_window" {
  description = "Number of days before a key actually gets deleted once it's been scheduled for deletion. Valid value between 7 and 30 days"
  type        = number
  default     = 30
  validation {
    condition     = var.deletion_window >= 7 && var.deletion_window <= 30
    error_message = "Please enter deletion_window value between 7 and 30."
  }
}

variable "service_key_info" {
  description = "Information required for a 'service' key"
  type = object({
    # List of AWS service names for the kms:ViaService policy condition
    aws_service_names = list(string)
    # List of caller account IDs for the kms:CallerAccount policy condition
    caller_account_ids = list(string)
  })
  default = {
    aws_service_names  = []
    caller_account_ids = []
  }
}

variable "direct_key_info" {
  description = "Information required for a 'direct' key"
  type = object({
    # List of principals to allow for cryptographic use of key.
    allow_access_from_principals = list(string)
  })
  default = {
    allow_access_from_principals = []
  }
}

variable "principal_type" {
  description = "Indicate which type of principal to use in direct_key_info: Must be one of the valid values allowed, Eg. AWS or Service"
  type        = string
  default     = "AWS"
  validation {
    condition     = length(var.principal_type) >= 3
    error_message = "The Principle type must be atleast 3 characters long."
  }

}

variable "custom_tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(any)
  default     = {}
}
