+++
title = "cloudflare/ruleset v0.2.0"
date = 2026-10-23T12:00:00-07:00
slug = "cloudflare-ruleset-v0.2.0"
description = "Workloads can own Cloudflare zones, records, rulesets and redirects (LIB-0030)"
+++

Builds [LIB-0030](https://github.com/noisypigeon/library/blob/main/docs/adr/LIB-0030-cloudflare-workload-kinds-and-zone-ownership.md) (#147).

**Workload kinds.** `cloudflare.bucket` (R2), `cloudflare.dnsRecord`, `cloudflare.ruleset` and `cloudflare.apexRedirect`, all maps.
- They sign in with the spoke's Cloudflare token and keep their state in the workload's Scaleway state bucket.
- `cloudflare.zone` fills `zone` for every entry that doesn't set its own.
- A record's `name` defaults to its key, and its `comment` to `workloads/<w>`.
- A bucket's `account_id` comes from `cloudflare.enc` as a sensitive variable, never a literal.

**Zone ownership.** A root `zones.yaml` gives each zone one owner: a workload, or `terraform` for hand-written leaves.
- A workload may act only on its own zones.
- root.hcl refuses a hand-written `terraform/cloudflare/<zone>/` leaf in a zone a workload owns.
- A `zones.yaml` change re-plans every workload leaf and every zone leaf.
- A spoke without `zones.yaml` is unchanged, as is every non-Cloudflare leaf: they render identically to v5.1.0.

**Refused before planning:**
- two rulesets in one zone and phase;
- a redirect-phase ruleset beside an `apexRedirect`;
- two `apexRedirect`s in one zone;
- duplicate records (`MX`, `TXT`, `CAA`, `SRV` and `NS` may repeat with different content);
- an `A`, `AAAA` or `CNAME` at `@`, or anything at `www`, where an `apexRedirect` holds placeholders;
- `account_id` or `zone_id` written;
- a zone not owned;
- an overlong R2 name.

**`cloudflare/ruleset` v0.2.0.** A `zone` input, looked up by apex as `dns-record` does. It's exactly one of `zone` or `zone_id`.

**`workflows/`:**
- `resolve-workloads.sh` and `generate-module-redirects.sh` gain the kinds, with `workload.schema.json` for `cloudflare/bucket` (without `account_id`) and `cloudflare/ruleset` (without `zone_id`).
- `terragrunt-run.yml` and `terragrunt-detect.yml` treat `zones.yaml` like `root.hcl`.

A spoke can declare Cloudflare kinds once garden builds with this `workflows/` release.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

[#152](https://github.com/noisypigeon/library/pull/152)
