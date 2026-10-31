+++
title = "backblaze/bucket v0.2.0"
date = 2026-10-17T12:00:00-07:00
slug = "backblaze-bucket-v0.2.0"
description = "Add exact_name input to backblaze/bucket"
+++

`backblaze/bucket` gains an optional `exact_name` input, which works the way it already does in `cloudflare/bucket`. When it's set, the bucket is named exactly that, bypassing the `{name_prefix}-{random}-{name_suffix}` scheme, and the module creates no `random_string` at all. `name_prefix` and `name_suffix` are now optional to match: set either `exact_name`, or both of them, and a validation rejects any mix of the two.

This is what LIB-0016 §2 needs. A spoke's B2 state backup bucket must be named exactly `<R2 state bucket name>-backup`, so its backup leaf sets `exact_name` from the R2 leaf's `name` output through a Terragrunt `dependency`, rather than drawing a random code of its own.

Existing callers that pass `name_prefix` and `name_suffix` plan no changes on upgrade. `random_string.suffix` now has a `count`, and a `moved` block carries the existing suffix over to `random_string.suffix[0]`, so the bucket keeps its name and isn't replaced.

🤖 Generated with [Claude Code](https://claude.com/claude-code)


PR: https://github.com/noisypigeon/library/pull/73
