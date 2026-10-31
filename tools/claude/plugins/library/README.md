# claude/plugins/library

A Claude Code plugin with the skills for working on the library itself,
runway's `tools/` (LIB-0049 §4, LIB-0050). Versioned as
`claude/plugins/library/vX.Y.Z`, continuing `claude-plugins/library/vX.Y.Z`, and
listed in [`../marketplace.json`](../marketplace.json).

| Skill | What it does |
| --- | --- |
| `release-pr` | The discipline for a change under `tools/`: branch, PR body, exactly one `release:*` label, merge. |

## Consuming a version

Each plugin version's page on garden,
`https://noisypigeon.garden/claude/plugins/library/vX.Y.Z/`, gives the
snippet. Pin the marketplace to this plugin's tag and enable the plugin in
the consuming repo's committed `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "library": {
      "source": { "source": "github", "repo": "noisypigeon/runway", "ref": "claude/plugins/library/vX.Y.Z" }
    }
  },
  "enabledPlugins": { "library@library": true }
}
```

The tag names a release commit that copies `tools/claude/plugins/marketplace.json`
to `.claude-plugin/marketplace.json`, where Claude Code reads it (LIB-0049 §4).
No `version` is set in `plugin.json` or the marketplace entry: the pinned tag
is the version.

## Editing

Change the skill here, open a PR with a `release:*` label, then bump the pin in
runway's `.claude/settings.json`.
