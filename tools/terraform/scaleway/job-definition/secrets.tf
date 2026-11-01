# Each secret environment variable is a Secret Manager secret of its own,
# read by this job alone (LIB-0053 §3). Keys are variable names, which aren't
# secret; values are.
locals {
  secret_values = merge(var.secret_env, var.secret_wiring)
}

resource "scaleway_secret" "env" {
  for_each   = nonsensitive(toset(keys(local.secret_values)))
  name       = "${var.name}-${lower(replace(each.key, "_", "-"))}"
  project_id = var.project_id
  tags       = ["serverless-job", var.name]
}

resource "scaleway_secret_version" "env" {
  for_each  = scaleway_secret.env
  secret_id = each.value.id
  data      = local.secret_values[each.key]
}
