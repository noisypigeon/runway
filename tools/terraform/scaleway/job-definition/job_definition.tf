resource "scaleway_job_definition" "this" {
  name                   = var.name
  project_id             = var.project_id
  image_uri              = var.image
  startup_command        = var.command
  args                   = var.args
  cpu_limit              = var.cpu
  memory_limit           = var.memory
  local_storage_capacity = var.storage
  timeout                = var.timeout
  env                    = var.env

  # Scaleway gives every definition a retry policy, so the module states it;
  # left out, every plan would try to remove it.
  retry_policy {
    max_retries = var.retries
  }

  dynamic "cron" {
    for_each = var.schedule == null ? [] : [var.schedule]
    content {
      schedule = cron.value
      timezone = var.timezone
    }
  }

  dynamic "secret_reference" {
    for_each = scaleway_secret_version.env
    content {
      secret_id      = secret_reference.value.secret_id
      secret_version = tostring(secret_reference.value.revision)
      environment    = secret_reference.key
    }
  }
}
