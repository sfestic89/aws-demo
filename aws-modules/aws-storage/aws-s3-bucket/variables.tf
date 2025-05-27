variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "bucket_prefix" {
  description = "Optional bucket prefix"
  type        = string
  default     = null
}

variable "grants" {
  description = "Access grants (ACL level)"
  type = list(object({
    id          = optional(string)
    type        = string
    uri         = optional(string)
    permissions = list(string)
  }))
  default = []
}

variable "force_destroy" {
  description = "Force destroy bucket even if not empty"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  type        = bool
  default     = true
}

variable "mfa_delete" {
  description = "Enable MFA delete (must be configured separately)"
  type        = string
  default     = null
}

variable "enable_encryption" {
  description = "Enable SSE"
  type        = bool
  default     = true
}

variable "encryption_algorithm" {
  type    = string
  default = "AES256"
}

variable "kms_key_id" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "logging_enabled" {
  type    = bool
  default = false
}

variable "logging_target_bucket" {
  type    = string
  default = ""
}

variable "logging_target_prefix" {
  type    = string
  default = "logs/"
}

variable "lifecycle_rules" {
  type = list(object({
    id     = string
    status = string
    prefix = optional(string)

    transition = optional(list(object({
      days          = number
      storage_class = string
    })))

    expiration = optional(list(object({
      days = number
    })))
  }))
  default = []
}

variable "replication_enabled" {
  type    = bool
  default = false
}

variable "replication_role_arn" {
  type    = string
  default = ""
}

variable "replication_rules" {
  type = list(object({
    id       = string
    status   = string
    priority = number
    filter = object({
      prefix = string
    })
    destination = object({
      bucket             = string
      storage_class      = string
      replica_kms_key_id = optional(string)
    })
  }))
  default = []
}
