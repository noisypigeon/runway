# The spoke's Cloudflare deployer token (LIB-0033 §2), minted by the bootstrap
# token in cloudflare_breakglass.enc, which can only mint. It mints each
# workload's own token in turn, so it needs only to mint, and to read zones
# for their scopes. runway's zones all belong to workloads (zones.yaml).
module "token" {
  source = "https://noisypigeon.garden/terraform/cloudflare/api-token/v0.1.0"

  account_id = local.cloudflare_account_id
  name       = "runway-cloudflare-deployer"
  policies = [
    { permission_groups = ["Account API Tokens Read", "Account API Tokens Write"], account = true },
    { permission_groups = ["Zone Read"], all_zones = true },
  ]
}
