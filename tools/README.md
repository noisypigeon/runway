# library

Reusable, versioned building blocks for the `noisypigeon` family: Terraform
modules, a Zola theme, a Terragrunt `root.hcl` template, and the shared CI that
releases and deploys them.

`tools/` is the **hub**, a directory of `noisypigeon/runway` since LIB-0047
hoisted the old `noisypigeon/library` repo into it, laid out by what each part
is since LIB-0050. It holds what other repos
reuse and nothing that is deployed: no site, no Terraform state, no secrets.
Paths below are relative to `tools/`, except `.github/`, `.claude/` and
`.pigeon/`, which sit at runway's root. A unit's tag is its path here. The repos that consume it
(`runway`, and what is left of `noisypigeon`) are spokes: content plus the
infrastructure that serves it, each pinning a version of what it takes from
here, runway included. `noisypigeon.com` and `noisypigeon.garden` are only Pages shims for the
sites runway holds as workloads. The full argument is
[LIB-0001](docs/adr/LIB-0001-composable-hub-and-spoke-repo-architecture.md).

## What's here

| Path | What | Tagged |
| --- | --- | --- |
| [`terraform/`](terraform) | Terraform modules (Scaleway, Cloudflare, Backblaze, Grafana) | `terraform/<provider>/<module>/vX.Y.Z` |
| [`static-site/zola/`](static-site/zola) | a reusable Zola theme, named `zola-site` in a site's config | `static-site/zola/vX.Y.Z` |
| [`github/terragrunt/`](github/terragrunt) | the spokes' Terragrunt `root.hcl` template | `github/terragrunt/vX.Y.Z` |
| [`github/workflows/`](github/workflows), [`github/scripts/`](github/scripts) and [`github/policies/`](github/policies) | the reusable CI the spokes call, the scripts it runs and the policies `check-policies.sh` reads. Each tag names a commit that copies the workflows into `.github/workflows/`, where GitHub runs them (LIB-0049) | `github/workflows/vX.Y.Z` |
| [`observability/lgtm-stack/`](observability/lgtm-stack) | a local Docker Compose observability stack | `observability/lgtm-stack/vX.Y.Z` |
| `observability/dashboards/<set>/` | versioned Grafana dashboard JSON, fetched by tag URL | `observability/dashboards/<set>/vX.Y.Z` |
| [`claude/plugins/`](claude/plugins) | Claude Code plugins, in the `library` marketplace | `claude/plugins/<plugin>/vX.Y.Z` |
| [`docs/`](docs) | the decision records and runbooks | not released |

Each renamed track continues the one before LIB-0050 (`zola-site/`,
`terragrunt/root-hcl/`, `workflows/`, `grafana-dashboards/<set>/`,
`observability/pigeon-cli/`, `claude-plugins/<plugin>/`), whose tags still
resolve.

Plus two scripts a site's build or generation runs:
[`static-site/zola/resolve-theme.sh`](static-site/zola/resolve-theme.sh) (materializes the
theme version a site pins) and
[`github/scripts/generate-module-redirects.sh`](github/scripts/generate-module-redirects.sh) (generates
`noisypigeon.garden`'s module pages and release posts from this repo's tags and
changelogs, committed in runway's `workloads/garden/`). Both resolve their own location rather than asking git, so they
work wherever a site fetched them to.

## What the CI track holds

Everything in [`github/`](github) but the template travels under one
`github/workflows/vX.Y.Z`, fetched into a consumer's `.pigeon/src/` by its
`.pigeon/tools.sh` at its `.pigeon/version`. A spoke pins one version, and gets the
reusable workflows and every script at it (LIB-0001 invariant 2).

- **`resolve-root-hcl.sh`** copies the `root.hcl` template and its secrets
  schema to a spoke's root, at `spoke.hcl`'s `root_hcl_version`. The spoke
  commits the copy, and CI runs the script with `--check` to fail on drift.
- **`resolve-workloads.sh`** generates every workload's and zone's unit stubs.
  A workload's come from its `workload.yaml`, and a zone's from its
  `zone.yaml`.
- **`check-secrets.sh` and `split-secrets.sh`.** `check-secrets.sh` checks a
  spoke's secrets files by key name against the schema. `split-secrets.sh` is
  the one-time v3→v4 migration.
- **`check-policies.sh`** checks a spoke against the policies its
  `policies.yaml` turns on, before every plan (LIB-0045).
- **`root-changelog.sh`** is the one implementation of DEV-0160's root
  changelog.
- **`generate-module-redirects.sh`** generates garden's pages from this repo's
  tags. That covers module redirects, theme versions, workflow and plugin
  version pages, release posts and schemas.
- **The crate release pipeline.** `rust-crate-release.yml`, `crate-*.sh` and
  `adr-issue.sh` were hoisted from pigeon-cli by its CLI-0161. They run in the
  caller's repo, and every crate-specific value is an input.
- **The site workflows.**
  - `site-dispatch.yml` dispatches a site's deploy in its Pages shim.
  - `site-pages.yml` is what the shim calls.
  - `site-generate.yml` commits a site's generated files before the deploy.
- **`container-image-release.yml`** builds a caller's Dockerfile per platform
  and smoke-tests each image. It then publishes one multi-arch,
  provenance-attested tag set to GHCR (LIB-0019).

## Consuming a module

Pin the short URL, not this repo:

```hcl
module "state_bucket" {
  source = "https://noisypigeon.garden/terraform/scaleway/bucket/v5.0.0"
  ...
}
```

`terraform init` resolves it through go-getter's HTTP discovery protocol to a
tagged `git::` source here. The public namespace is `modules/...`, **not**
`terraform/...` — it is a stable public interface, deliberately decoupled from
this repo's internal layout. That decoupling is why flattening these
directories, and re-cutting all 53 tags, changed no consumer's `source =` line.

See [`terraform/README.md`](terraform/README.md) for the full contract,
including the equivalent hand-written `git::` form and how to iterate locally
against an unreleased change.

## Consuming the theme

A site sets `theme = "zola-site"` and `[extra].theme_version` in its
`config.toml`, fetches this repo, and runs
[`static-site/zola/resolve-theme.sh`](static-site/zola/resolve-theme.sh) before building. See
[`static-site/zola/README.md`](static-site/zola/README.md).

## Releasing

Every change ships through a labelled PR — the PR body becomes the changelog
entry and GitHub Release notes verbatim, and the `release:*` label drives the
version bump. See
the `release-pr` skill, in the [`library` plugin](claude/plugins/library/skills/release-pr/SKILL.md),
which is the discipline; [`template-release.yml`](../.github/workflows/template-release.yml) is the
automation that acts on it.

Every merged PR also adds one line to runway's root [`CHANGELOG.md`](../CHANGELOG.md).
This directory's [`CHANGELOG.md`](CHANGELOG.md) is the library's, up to the hoist.
Each unit's own `CHANGELOG.md` has one line per release, and its full notes are
its GitHub Release (LIB-0049 §7).

## Decision records

The family's ADRs live in [`docs/adr/`](docs/adr), as `LIB-NNNN-<slug>.md`.
The spokes (runway, and the shims) have none of their own, because they
depend on the library for their design standards
([LIB-0017](docs/adr/LIB-0017-spokes-do-not-get-their-own-adrs.md)). The older
`DEV-` records are archived verbatim in [`docs/adr/archive/`](docs/adr/archive),
and the `COM-` and `RUN-` records (`NPC-` is an alias for `COM-`) are amendments
on the `LIB-` records they applied. `pigeon-cli` keeps its own ADRs, as `CLI-` records in its `adr/`.
