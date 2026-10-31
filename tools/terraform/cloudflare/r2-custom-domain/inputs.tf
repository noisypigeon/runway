variable "account_id" {
  type        = string
  description = "Cloudflare account ID the bucket belongs to (in a spoke leaf, local.cloudflare_account_id)"
}

variable "zone" {
  type        = string
  description = "Apex domain of the Cloudflare zone the hostname is in, e.g. \"example.com\". The zone ID is looked up from it"
}

variable "bucket_name" {
  type        = string
  description = "Name of the R2 bucket to serve, e.g. cloudflare/bucket's `name` output, or its exact_name"
}

variable "domain" {
  type        = string
  description = "Full hostname to serve the bucket on, e.g. \"example.com\" or \"www.example.com\""

  validation {
    condition     = var.domain == var.zone || endswith(var.domain, ".${var.zone}")
    error_message = "domain must be the zone's apex or a name under it."
  }
}

variable "enabled" {
  type        = bool
  description = "Whether the hostname serves the bucket"
  default     = true
  nullable    = false
}

variable "min_tls" {
  type        = string
  description = "Minimum TLS version the hostname accepts (1.0, 1.1, 1.2, 1.3)"
  default     = "1.2"
  nullable    = false

  validation {
    condition     = contains(["1.0", "1.1", "1.2", "1.3"], var.min_tls)
    error_message = "min_tls must be one of 1.0, 1.1, 1.2 or 1.3."
  }
}
