+++
title = "grafana/dashboard v0.2.0"
date = 2026-10-15T12:00:00-07:00
slug = "grafana-dashboard-v0.2.0"
description = "grafana-dashboard: dashboards by URL, and an optional first-access hook"
+++

Two additive changes to `scaleway/grafana-dashboard`. Existing callers that pass `config_json` and nothing else are unchanged.

### Dashboards by URL

Each `dashboards` entry may now give `url` instead of `config_json`:

```hcl
dashboards = {
  overview = { url = "https://raw.githubusercontent.com/noisypigeon/pigeon-lib/refs/tags/grafana-dashboards/pigeon-cli/v1.0.0/grafana-dashboards/pigeon-cli/overview.json" }
}
```

- The module fetches the URL at plan time with `hashicorp/http`, which is a new provider requirement (`~> 3.4`).
- A non-200 response fails the plan, so an error page is never applied as a dashboard.
- Each entry must set exactly one of `config_json` or `url`; validation enforces it.

This is how a leaf pins a version from the new `grafana-dashboards/<set>` track, without keeping its own copy of the JSON.

### Optional first-access hook

Scaleway's Grafana provisions an IAM identity's role lazily, on its first API access, and no resource does that (ADR-0135). Leaves have carried a `terraform_data` curl hook as glue to handle it. The module can now run it:

- `first_access = { grafana_url, trigger }` with a sensitive `first_access_auth_token`.
- It runs once before the folder and dashboards are created, and again whenever `trigger` changes. Pass the IAM application ID.
- The token is a separate variable on purpose. Terraform won't base `count` on a sensitive value, so the hook's settings must stay non-sensitive.

Moving a leaf's existing hook in is an address change only, done with one `moved` block. The README has it.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

[#31](https://github.com/noisypigeon/pigeon-lib/pull/31)
