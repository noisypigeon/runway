# The spoke's Cloudflare deployer token (LIB-0033 §2), minted by the bootstrap
# token in cloudflare_breakglass.enc. Cloudflare won't let a minted token mint,
# so it holds only what hand-written Cloudflare leaves need -- runway has none
# yet -- and replaces the bootstrap token in cloudflare.enc. Workload tokens are
# minted with the bootstrap token directly (LIB-0033's second amendment).
module "token" {
  source = "https://noisypigeon.garden/terraform/cloudflare/api-token/v0.1.0"

  account_id = local.cloudflare_account_id
  name       = "runway-cloudflare-deployer"
  policies = [
    { permission_groups = ["Zone Read"], all_zones = true },
  ]
}
