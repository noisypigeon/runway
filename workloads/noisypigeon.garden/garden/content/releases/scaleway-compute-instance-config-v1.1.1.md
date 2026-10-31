+++
title = "scaleway/compute-instance-config v1.1.1"
date = 2026-10-28T12:00:00-07:00
slug = "scaleway-compute-instance-config-v1.1.1"
description = "Treat a null keyring_wiring or keyring_secrets as empty"
+++

`keyring_wiring` and `keyring_secrets` are now `nullable = false`, so passing `null` gives each its default, `{}`. A workload stub declares every wiring input it doesn't fill as a variable defaulting to `null` (LIB-0023 §4). In v1.1.0, a null `keyring_wiring` reached the alias precondition's `keys()` and failed the plan with a function error instead of rendering the keyring unchanged.

Nothing else changes. Verified in a scratch root: with both inputs `null`, the document is identical to v1.0.0's.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

PR: https://github.com/noisypigeon/library/pull/223
