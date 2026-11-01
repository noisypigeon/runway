# A Scaleway Serverless Job definition (LIB-0053). Each input is named for the
# workload entry key that sets it, so an entry passes straight through.

variable "name" {
  type        = string
  description = "Job definition name"
}

variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "image" {
  type        = string
  description = "Container image, pinned to a tag or a digest, e.g. ghcr.io/noisypigeon/pigeon-cli:v1.2.3. The registry must allow anonymous pulls."

  validation {
    condition     = can(regex("(:[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}|@sha256:[0-9a-f]{64})$", var.image)) && !endswith(var.image, ":latest")
    error_message = "image must be pinned to a tag other than latest, or to a sha256 digest."
  }
}

variable "command" {
  type        = list(string)
  description = "Startup command, overriding the image's entrypoint. Null keeps the image's."
  default     = null
}

variable "args" {
  type        = list(string)
  description = "Arguments to the startup command. Null keeps the image's."
  default     = null
}

variable "cpu" {
  type        = number
  description = "vCPU for each run, in mvCPU (1000 is one vCPU)"
  default     = 1000
}

variable "memory" {
  type        = number
  description = "Memory for each run, in MB"
  default     = 2048
}

variable "storage" {
  type        = number
  description = "Local storage for each run, in MiB"
  default     = 10240
}

variable "timeout" {
  type        = string
  description = "A run's timeout, as a Go duration, e.g. 2h30m"
  default     = "1h"
}

variable "retries" {
  type        = number
  description = "How many times Scaleway retries a failed run (its retry_policy.max_retries). Scaleway sets 0 itself, so the default matches it and plans No changes."
  default     = 0
  nullable    = false

  validation {
    condition     = var.retries >= 0 && floor(var.retries) == var.retries
    error_message = "retries must be a whole number, 0 or more."
  }
}

variable "schedule" {
  type        = string
  description = "Cron schedule, e.g. \"15 3 * * *\". Set, the job is recurring and Scaleway starts its runs; null, it is ad hoc."
  default     = null
}

variable "timezone" {
  type        = string
  description = "The schedule's time zone, a tz database name"
  default     = "Europe/London"
}

variable "env" {
  type        = map(string)
  description = "Plain environment variables. Never a secret: those go in secret_env or secret_wiring."
  default     = {}
  nullable    = false
}

variable "secret_env" {
  type        = map(string)
  description = "Environment variables that are secrets, by variable name: a workload's secretRefs, resolved. Each is stored in Secret Manager and reaches the run by secret reference."
  default     = {}
  sensitive   = true
  nullable    = false
}

variable "secret_wiring" {
  type        = map(string)
  description = "Environment variables wired from another leaf, e.g. an API key's secret, by variable name. Stored and referenced as secret_env is."
  default     = {}
  sensitive   = true
  nullable    = false
}
