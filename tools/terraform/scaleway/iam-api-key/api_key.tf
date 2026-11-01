# A rotation generation above 0 replaces the key at once (LIB-0054 §6). It
# re-creates the timestamps too, so the new key's expiry starts from now; at
# 0 nothing changes, so existing keys plan No changes.
locals {
  generation_triggers = var.rotation_generation == 0 ? null : { generation = tostring(var.rotation_generation) }
}

resource "time_static" "created" {
  triggers = local.generation_triggers
}

# With rotation_days (LIB-0038 §2, as LIB-0024 §4 gave the deployer), the key
# is replaced every rotation_days and expires a week after each scheduled
# rotation, so a month without a plan doesn't strand whoever signs in with it.
# The addresses are terraform-deployer-iam's, so a deployer's key moves here
# with its rotation timestamp.
resource "time_rotating" "key" {
  count         = var.rotation_days == null ? 0 : 1
  rotation_days = var.rotation_days
  triggers      = local.generation_triggers
}

# replace_triggered_by can't name a resource that may have no instances, so the
# rotation is carried by one that always exists. Its input changes, and so
# triggers the key's replacement, only when time_rotating rotates or the
# rotation generation is bumped.
resource "terraform_data" "rotation" {
  input = var.rotation_generation == 0 ? try(time_rotating.key[0].id, "none") : "${try(time_rotating.key[0].id, "none")}#${var.rotation_generation}"
}

resource "scaleway_iam_api_key" "api_key" {
  application_id = var.application_id
  description    = var.description
  expires_at = coalesce(
    var.expires_at,
    var.rotation_days == null ? timeadd(time_static.created.rfc3339, "720h") : timeadd(time_rotating.key[0].rotation_rfc3339, "168h"),
  )
  default_project_id = var.default_project_id

  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [terraform_data.rotation]
  }
}
