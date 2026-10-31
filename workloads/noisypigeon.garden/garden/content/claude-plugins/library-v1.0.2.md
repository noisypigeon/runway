+++
title = "claude/plugins/library v1.0.2"
description = "The library Claude Code plugin at claude/plugins/library/v1.0.2."
path = "claude/plugins/library/v1.0.2"
template = "plugin-version.html"
weight = 1000002

[extra]
plugin = "library"
version = "1.0.2"
github_url = "https://github.com/noisypigeon/runway/releases/tag/claude/plugins/library/v1.0.2"
+++

Skills for working on the library, runway's lib/: release-pr is the discipline for getting a lib/ change released.

Pin the `library` marketplace to this version and enable the plugin in the
consuming repo's committed `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "library": {
      "source": { "source": "github", "repo": "noisypigeon/runway", "ref": "claude/plugins/library/v1.0.2" }
    }
  },
  "enabledPlugins": { "library@library": true }
}
```

If Claude Code reports the plugin is enabled but not installed, run
`claude plugin install library@library --scope project` once.

[Source at this tag](https://github.com/noisypigeon/runway/tree/claude/plugins/library/v1.0.2/tools/claude/plugins/library)
