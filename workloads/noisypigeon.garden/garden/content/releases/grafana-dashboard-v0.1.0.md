+++
title = "grafana/dashboard v0.1.0"
date = 2026-10-06T12:00:00-07:00
slug = "grafana-dashboard-v0.1.0"
description = "Add grafana-dashboard module"
+++

`scaleway/grafana-dashboard` moves to `grafana/dashboard`. It uses only the `grafana` provider (plus `hashicorp/http`) and nothing from Scaleway, so its path now says what it is.

### What changes for a consumer

Only the source URL:

```hcl
source = "https://pigeon.dev/modules/grafana/dashboard/v0.1.0"
```

- **`grafana/dashboard` v0.1.0 is `scaleway/grafana-dashboard` v0.2.0, unchanged.** It has the same inputs, outputs and resource addresses, so repointing a leaf at it plans `No changes.` without any `moved` blocks.
- **The new path starts its own tag track at v0.1.0.** The module's `CHANGELOG.md` keeps the history of 0.1.0 and 0.2.0 under the old name, with a note saying so.
- **The old short URLs keep resolving.** `pigeon.dev/modules/scaleway/grafana-dashboard/v0.1.0` and `v0.2.0` are generated from their tags, which stay. That path just gets no new versions.

Moving a spoke's leaf to `terraform/grafana/dashboard/<instance>/`, as LIB-0004 asks, is a state move in that spoke and not part of this release.

The README's input/output table is regenerated too. It had gone stale because `module-docs.yml` doesn't cover this module (noisypigeon/noisypigeon#302).

🤖 Generated with [Claude Code](https://claude.com/claude-code)


PR: https://github.com/noisypigeon/pigeon-lib/pull/35
