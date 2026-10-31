# One account-owned Cloudflare API token (LIB-0033 §3). Policies name their
# permission groups and resources, never opaque IDs: the groups are looked up
# by name, and zones by apex as dns-record v1 does (LIB-0011).

data "cloudflare_account_api_token_permission_groups_list" "all" {
  account_id = var.account_id
}

data "cloudflare_zone" "this" {
  for_each = toset(flatten([for p in var.policies : p.zones]))

  filter = {
    name = each.value
  }
}

locals {
  # bucket_scope is an R2 bucket, by account, jurisdiction and name. Every
  # family bucket is in the eu jurisdiction (LIB-0006).
  zone_scope    = "com.cloudflare.api.account.zone"
  account_scope = "com.cloudflare.api.account"
  bucket_scope  = "com.cloudflare.edge.r2.bucket"
  groups        = data.cloudflare_account_api_token_permission_groups_list.all.result

  # A name may exist at several scopes, so each policy resolves its names at
  # the scope its resources need.
  wanted = [for p in var.policies : p.account ? local.account_scope : length(p.r2_buckets) > 0 ? local.bucket_scope : local.zone_scope]
  resolved = [
    for i, p in var.policies : [
      for name in p.permission_groups :
      try([for g in local.groups : g if g.name == name && contains(g.scopes, local.wanted[i])][0], null)
    ]
  ]
  # Names with no group at that scope, or one the caller may not grant.
  unknown    = distinct(flatten([for i, p in var.policies : [for j, name in p.permission_groups : name if local.resolved[i][j] == null]]))
  unselected = distinct(flatten([for i, p in var.policies : [for g in local.resolved[i] : g.name if g != null && !g.is_selectable]]))
  # For an unknown name, the groups that share a word of four letters or
  # more with it, with their scopes, so the error names what does exist.
  near = distinct(flatten([
    for name in local.unknown : [
      for g in local.groups : "${g.name} (${join(", ", [for sc in g.scopes : trimprefix(sc, "com.cloudflare.")])})"
      if anytrue([for w in split(" ", lower(name)) : length(w) >= 4 && strcontains(lower(g.name), w) && !contains(["read", "write"], w)])
    ]
  ]))

  resources = [
    for p in var.policies : (
      p.account ? jsonencode({ "${local.account_scope}.${var.account_id}" = "*" }) :
      p.all_zones ? jsonencode({ "${local.account_scope}.${var.account_id}" = { "${local.zone_scope}.*" = "*" } }) :
      length(p.r2_buckets) > 0 ? jsonencode({ for b in p.r2_buckets : "${local.bucket_scope}.${var.account_id}_eu_${b}" => "*" }) :
      jsonencode({ for z in p.zones : "${local.zone_scope}.${data.cloudflare_zone.this[z].id}" => "*" })
    )
  ]
}

resource "time_static" "created" {}

# With rotation_days, the token is replaced every rotation_days and expires a
# week after each scheduled rotation, as scaleway/terraform-deployer-iam's key
# does (LIB-0024 §4).
resource "time_rotating" "token" {
  count         = var.rotation_days == null ? 0 : 1
  rotation_days = var.rotation_days
}

# replace_triggered_by can't name a resource that may have no instances, so the
# rotation is carried by one that always exists.
resource "terraform_data" "rotation" {
  input = try(time_rotating.token[0].id, "none")
}

resource "cloudflare_account_token" "this" {
  account_id = var.account_id
  name       = var.name
  expires_on = coalesce(
    var.expires_on,
    var.rotation_days == null ? timeadd(time_static.created.rfc3339, "8760h") : timeadd(time_rotating.token[0].rotation_rfc3339, "168h"),
  )

  policies = [
    for i, p in var.policies : {
      effect            = p.effect
      permission_groups = [for g in local.resolved[i] : { id = g.id } if g != null]
      resources         = local.resources[i]
    }
  ]

  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [terraform_data.rotation]

    precondition {
      condition     = length(local.unknown) == 0
      error_message = "No permission group named ${join(", ", local.unknown)} at the scope its policy needs. Groups with a word in common: ${length(local.near) > 0 ? join("; ", local.near) : "none"}."
    }
    precondition {
      condition     = length(local.unselected) == 0
      error_message = "The signing-in token may not grant ${join(", ", local.unselected)} (is_selectable is false); widen it, or drop them (LIB-0033 Verification 6)."
    }
  }
}
