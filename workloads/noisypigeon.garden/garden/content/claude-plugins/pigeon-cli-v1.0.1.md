+++
title = "claude-plugins/pigeon-cli v1.0.1"
description = "The pigeon-cli Claude Code plugin at claude-plugins/pigeon-cli/v1.0.1."
path = "claude-plugins/pigeon-cli/v1.0.1"
template = "plugin-version.html"
weight = 1000001

[extra]
plugin = "pigeon-cli"
version = "1.0.1"
github_url = "https://github.com/noisypigeon/runway/releases/tag/claude-plugins/pigeon-cli/v1.0.1"
+++

Skills for working on pigeon-cli: analyze-job-run diagnoses a pigeon job run from its JSONL log and metrics.

Pin the `library` marketplace to this version and enable the plugin in the
consuming repo's committed `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "library": {
      "source": { "source": "github", "repo": "noisypigeon/runway", "ref": "claude-plugins/pigeon-cli/v1.0.1" }
    }
  },
  "enabledPlugins": { "pigeon-cli@library": true }
}
```

If Claude Code reports the plugin is enabled but not installed, run
`claude plugin install pigeon-cli@library --scope project` once.

[Source at this tag](https://github.com/noisypigeon/runway/tree/claude-plugins/pigeon-cli/v1.0.1/lib/claude-plugins/pigeon-cli)
