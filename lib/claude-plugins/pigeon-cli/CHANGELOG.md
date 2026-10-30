# Changelog

All notable changes to this release unit are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.1] - 2026-10-29

### Point the template, theme and plugin at runway (LIB-0047)

The library now lives in `noisypigeon/runway` under `lib/` (LIB-0047). This release points the parts of the `root.hcl` template, the theme and the `pigeon-cli` plugin that name the library's address at runway instead. Nothing else about how any of them behaves changes.

- **`terragrunt/root-hcl`:** a workload or zone leaf lists its module's tags from `https://github.com/noisypigeon/runway` when `LIB_TAG_REMOTE` is unset, rather than from the archived library. The tags have the same names in both, so a leaf resolves the same version either way. The header comment and the secrets schema now name the scripts at `lib/scripts/`. A spoke takes this by bumping `root_hcl_version` and regenerating `root.hcl`.
- **`zola-site`:** the theme's `homepage` in `theme.toml` points at `lib/zola-site` in runway. Nothing a site renders changes.
- **`claude-plugins/pigeon-cli`:** the marketplace at runway's root now finds the plugin at `./lib/claude-plugins/pigeon-cli`. The marketplace at the earlier tag still names the plugin's pre-hoist path, which doesn't exist in runway, so a consumer pinning the marketplace to runway must pin this tag or later. The plugin's `repository` now names runway too. Its skills are unchanged.

The library's docs move with it: `lib/README.md`, `lib/CLAUDE.md` and the module and dashboard READMEs now give runway's URLs and paths, including the `lib/` segment in raw dashboard URLs and hand-written `git::` sources.

🤖 Generated with [Claude Code](https://claude.com/claude-code)


[#103](https://github.com/noisypigeon/runway/pull/103)

## [1.0.0] - 2026-10-19

### Add pigeon-cli's observability stack and Claude Code plugin

Hoists two more of `pigeon-cli`'s assets into the library, per its [CLI-0161](https://github.com/noisypigeon/pigeon-cli/pull/133). Each gets its own per-set release track.

- **`observability/pigeon-cli/`**, released as `observability/pigeon-cli/vX.Y.Z`. This is pigeon-cli's local Docker Compose stack: Prometheus, Loki, Promtail and Grafana. Grafana no longer keeps its own copy of the dashboard. It mounts `grafana-dashboards/pigeon-cli/` from the same checkout, so there is one dashboard to edit. The compose project name is pinned to `observability`, so an existing stack keeps its Prometheus and Grafana volumes across the move.
- **`claude-plugins/pigeon-cli/`**, released as `claude-plugins/pigeon-cli/vX.Y.Z`. This is a Claude Code plugin holding the `analyze-job-run` skill. The repo root gains `.claude-plugin/marketplace.json`, a marketplace named `library`. A consumer pins the marketplace to the plugin's tag in its `.claude/settings.json` and enables `pigeon-cli@library`.
- **`grafana-dashboards/pigeon-cli`**: the `instance` variable's "All" is now `.*`. Its values come from node-exporter, so on a stack without one, "All" used to match nothing and every pigeon panel came up empty. On Cockpit, "All" still means every instance.
- **`template-release.yml`** treats `observability/<set>/` and `claude-plugins/<set>/` like `grafana-dashboards/<set>/`: one release track per set, and a set's README/CHANGELOG are never a release on their own.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

[#82](https://github.com/noisypigeon/library/pull/82)
