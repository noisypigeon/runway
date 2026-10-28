+++
title = "backblaze/api-key v0.2.0"
date = 2026-10-28T12:00:00-07:00
slug = "backblaze-api-key-v0.2.0"
description = "A workload's own Backblaze key, and providers with no spoke-wide credentials"
+++

A workload with Backblaze buckets or keys now gets its own Backblaze key, and a spoke can keep no spoke-wide Backblaze key or Cloudflare token at all (LIB-0041).

**A workload's own Backblaze key.** Any workload that declares a `backblaze.bucket` or `backblaze.apiKey` gets an implicit leaf, `backblaze/api-key/deployer`, the Backblaze twin of its Cloudflare token.
- It's minted with the spoke's Backblaze breakglass key where the spoke has one, and with `backblaze.enc`'s key otherwise.
- It's account-wide, since B2 can't confine a key to buckets that don't exist yet.
- It rotates every 30 days, and each key expires a week after its rotation.
- It's named `<prefix>-<suffix><unit tag>-backblaze-deployer`. `backblaze.deployer` overrides any of its inputs, and `backblaze.apiKey.deployer` is reserved.

**The workload's Backblaze leaves sign in with it.** Each `backblaze/bucket` and `backblaze/api-key` stub now depends on the key and passes its ID and secret to `provider "b2"`. Taking the bump plans `+1` per such workload. Its Backblaze leaves are deferred until the key applies, then plan `No changes.`, since only their provider's credentials change.

**`workloads_only`.** A Cloudflare or Backblaze entry in `spoke.hcl`'s `providers` may set `workloads_only = true` with `breakglass = {}`.
- No hand-written leaf turns the provider on.
- `backblaze.enc`, and `cloudflare.enc`'s `CLOUDFLARE_PROVIDER_TOKEN`, are no longer required. Any that remain are refused.
- The breakglass key mints every unit's own key or token.

The secrets schema expresses this as a new condition, `spoke_credentials.<name>`. Both root.hcl and `check-secrets.sh` enforce it. root.hcl now checks a file's keys against the spoke-wide conditions, as `check-secrets.sh` does, so a leaf that reads `cloudflare.enc` only for the R2 backend no longer flags a key another leaf needs. A spoke that doesn't set `workloads_only` needs no changes.

**`terraform/backblaze/api-key`** gains `rotation_days`. It replaces the key create-before-destroy on that schedule, and each key expires a week later. It overrides `valid_duration_in_seconds`, and it defaults to null, so existing callers keep their fixed expiry. Each existing caller does plan one new `terraform_data.rotation` resource on upgrade, as `cloudflare/api-token` did.

**The published workload schema** gains `backblaze.deployer`.

🤖 Generated with [Claude Code](https://claude.com/claude-code)


[#208](https://github.com/noisypigeon/library/pull/208)
