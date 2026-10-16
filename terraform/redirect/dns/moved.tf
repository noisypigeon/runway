# The raw resources this leaf used to declare, moved under the
# cloudflare/dns-record and cloudflare/ruleset modules without touching the
# records or the ruleset themselves (LIB-0004 §3).
moved {
  from = cloudflare_dns_record.placeholder_apex
  to   = module.dns_record["placeholder_apex"].cloudflare_dns_record.this
}

moved {
  from = cloudflare_dns_record.placeholder_www
  to   = module.dns_record["placeholder_www"].cloudflare_dns_record.this
}

moved {
  from = cloudflare_ruleset.to_noisypigeon_com
  to   = module.ruleset.cloudflare_ruleset.this
}
