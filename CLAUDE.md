# CLAUDE.md

`noisypigeon/runway` is the Terraform for `willowgraysen.com`'s
infrastructure: pigeon-cli's object storage, job cluster, observability and
Grafana, the data-ops cold-storage buckets, and the IAM that ties them
together.

It also holds the two public sites, as the `blog` workload (LIB-0032) and the
`garden` workload (LIB-0035):

- **`workloads/noisypigeon.com/blog/`** is the noisypigeon.com Zola site
  (`config.toml`, `content/`, `static/`, `CHANGELOG.md`), beside its
  `workload.yaml` (LIB-0037). It lives in its zone's project, and the zone's
  `hosts` gives it the apex and `www`.
- **`noisypigeon/noisypigeon.com` is now only the Pages shim** (LIB-0031,
  LIB-0037 §4), implied by `workload.yaml`'s `deployments.githubPages`.
  Merging a site change here dispatches its `pages.yml`, which builds this
  repo's `main`. A post is a PR like any other, but only `workload.yaml` and
  `secrets.workload.yaml` changes run a plan.
- **`workloads/noisypigeon.garden/garden/`** is the noisypigeon.garden Zola
  site. Its shim is `noisypigeon/noisypigeon.garden`.
- **Each site's two Pages records** were imported, not created, and its
  `deployments.githubPages` implies them, so change one only on purpose.
- **Most of garden is generated.** Its module redirect pages under
  `content/terraform/`, `content/theme-versions/` and `content/releases/`, its
  version pages under `content/workflows/` and `content/claude-plugins/`, and
  its schemas under `static/terraform/` and `static/schemas/`, come from
  `garden-generate.yml`, which the library dispatches on every release. They
  are committed, so a short URL is a file with a history. Never hand-edit them:
  run the workflow. Every `terraform init`, this repo's included, resolves
  through them.

Each Cloudflare zone is a unit of its own (LIB-0036), at
`zones/<zone>/zone.yaml`: noisypigeon.com, pigeon.dev, willowgraysen.com and
noisypigeon.garden. A zone has its own Scaleway project, named for the domain,
and its own deployer, state bucket and Cloudflare token, named by its short
`prefix`. It holds the records that belong to the domain rather than a site,
and its `hosts` names the workload that serves each host, which lives under
`workloads/<zone>/` in the zone's project (LIB-0037). Its stubs are
generated, like a workload's.

The personal cold-storage buckets are the `personal-cold-storage` workload
(LIB-0040, LIB-0044), at `workloads/private/personal-cold-storage/`, and the
custodial bucket is the `custodial-cold-storage` workload, at
`workloads/private/custodial-cold-storage/`. Neither has a zone, so each has
its own project, `wg-personal-cold-storage` and `custodial-cold-storage`, whose
only job is to hold its buckets' state.

The Scaleway project everything under `terraform/scaleway/` lives in is the
`data-ops` workload's, `wg-data-ops` (LIB-0046), at
`workloads/private/data-ops/`. It was this spoke's hand-written project,
`runway`, renamed in place, so `SCALEWAY_PROVIDER_PROJECT_ID` still names it.
`terraform/scaleway/project/runway` only looks it up. pigeon-cli's buckets
are the workload's `scaleway.bucket` entries; its cluster, Cockpit and IAM,
and the spoke's state bucket, stay hand-written in the project for now.

The library lives in this repo, under `tools/` (LIB-0047, LIB-0049, LIB-0050): modules,
reusable workflows, scripts, plugins, decision records and runbooks. Read
[The library](#the-library-tools) before you change anything under it.

## Sensitive: read this first

The repo is public, and the account behind it holds custodial and archival
data.

- **Everything pushed is public and permanent.** That includes commits, branch
  names, PR titles and bodies, issues and CI logs.
- **Never paste plan output, bucket names, key IDs or secrets** anywhere,
  library records included. Describe resources by role, such as "the cold
  buckets". CI masks secret values, not names.
- **Never decrypt a `terraform/secrets/*.enc` file to a file.** Use
  `mise run secrets-edit <file>`.
- **Read the whole plan before `terragrunt apply`.** Destroying a cold bucket
  is unrecoverable.

## Dev cycle

- Every change is a PR with a Conventional Commit title. There is no human
  reviewer.
- `CHANGELOG.md` is generated, one line per merged PR. Don't hand-edit it.
- A PR outside `tools/` takes no `release:*` label, and releases nothing. A PR
  that changes a `tools/` unit takes exactly one (see
  [Releasing a `tools/` change](#releasing-a-tools-change)).
- Take a library change by bumping `.pigeon/version` and the
  `@github/workflows/vX.Y.Z` refs, `root_hcl_version` in `spoke.hcl`, or the
  plugin pin in `.claude/settings.json`. Never track a branch. For local
  iteration, point `PIGEON_SRC` at a checkout of this repo.
- `fetch-lib.sh` and `.lib-version` are kept only for the Pages shims, frozen at
  `workflows/v9.4.3` (LIB-0050's amendment). Don't bump or use them.

## The library: `tools/`

`tools/` is the library, the hub of LIB-0001's hub and spokes, hoisted into this
repo by LIB-0047, finished by LIB-0049 and laid out by LIB-0050. It holds
everything in the family that is reusable and versioned, and nothing that is
deployed. Each unit is its own tag track, and its tag is its path under
`tools/`. A track LIB-0050 renamed continues its old one's numbers, and its old
tags still resolve:

| Unit | Path | Tag | Consumed by |
| --- | --- | --- | --- |
| A Terraform module | `tools/terraform/<provider>/<module>/` | `terraform/<provider>/<module>/vX.Y.Z` | `noisypigeon.garden/terraform/<provider>/<module>/vX.Y.Z`, a stable interface of its own (LIB-0009) |
| The theme | `tools/static-site/zola/` | `static-site/zola/vX.Y.Z` (was `zola-site/`) | a site's `[extra].theme_version`, through `resolve-theme.sh` |
| The `root.hcl` template | `tools/github/terragrunt/` | `github/terragrunt/vX.Y.Z` (was `terragrunt/root-hcl/`) | `spoke.hcl`'s `root_hcl_version` (LIB-0003) |
| The reusable CI, its scripts and policies | `tools/github/workflows/`, `scripts/`, `policies/` | `github/workflows/vX.Y.Z` (was `workflows/`) | `uses:` and `.pigeon/version`; `noisypigeon.garden/github/workflows/vX.Y.Z/` names each `uses:` line |
| A dashboard set | `tools/observability/dashboards/<set>/` | `observability/dashboards/<set>/vX.Y.Z` (was `grafana-dashboards/<set>/`) | its raw URL at the tag |
| An observability stack | `tools/observability/<stack>/`, e.g. `lgtm-stack` | `observability/<stack>/vX.Y.Z` (`lgtm-stack` was `pigeon-cli`) | a checkout of the tag |
| A Claude Code plugin | `tools/claude/plugins/<plugin>/` | `claude/plugins/<plugin>/vX.Y.Z` (was `claude-plugins/`) | the `library` marketplace pinned at the tag; `noisypigeon.garden/claude/plugins/<plugin>/vX.Y.Z/` gives the settings |

- **GitHub reads two units only from the repo root.** A reusable workflow runs
  only from `.github/workflows/`, and a `github` marketplace is read from
  `.claude-plugin/marketplace.json`. So a `github/workflows/` or
  `claude/plugins/` tag names a release commit off `main` that copies
  `tools/github/workflows/*.yml` or `tools/claude/plugins/marketplace.json`
  there (LIB-0049 §§2, 4). `main`'s
  `.github/workflows/` holds only runway's own workflows, and `scripts-test`
  fails if a reusable one lands there.
- **runway consumes `tools/` only by pinned tag** (LIB-0001 invariant 2).
  `.pigeon/tools.sh` clones this repo into `.pigeon/src/` at `.pigeon/version`,
  and the callers name
  `noisypigeon/runway/.github/workflows/<w>.yml@github/workflows/vX.Y.Z`. Scripts
  then run from `.pigeon/src/tools/github/scripts/`. The `release-pr` skill
  comes from the `library` plugin, pinned in `.claude/settings.json`. A change
  under `tools/` reaches runway only when a later PR bumps the pin. Never
  consume `tools/` at `HEAD`.
- **Scripts resolve from their own location.** `resolve-theme.sh`,
  `generate-module-redirects.sh` and the others find their tree from
  `${BASH_SOURCE[0]}`, never from `git rev-parse`, because they run inside a
  clone fetched into another checkout. A resolver tries a version's new track
  first, then its old one, and reads each tag at its own prefix (`tools/` or
  `lib/`). `tools/README.md` and `tools/terraform/README.md` hold the per-unit
  detail.
- **The Pages shims' `pages.yml` can't live here.** `actions/deploy-pages`
  deploys only the calling repo's site (DEV-0156). Each shim's `pages.yml` is
  one `uses:` of `site-pages.yml` (LIB-0035 §3).
- **The archived `noisypigeon/library` keeps every tag it had,** so an old pin
  still resolves.

### Releasing a `tools/` change

The `release-pr` skill is the discipline. A PR that changes a unit carries
exactly one `release:*` label, and `template-release.yml` does the rest on
merge:

1. it bumps each changed unit's version;
2. it writes the unit's `CHANGELOG.md` and the root line;
3. it cuts the tag and the GitHub Release, whose notes are the PR body;
4. it dispatches `garden-generate.yml`, and for a theme release the blog
   shim's `pages.yml`.

runway writes the library tracks' tags, and no tag of its own, for a leaf, a
workload or a site (LIB-0047 §4).

A unit releases only when its predicate matches:

- a module: a changed `.tf` under it;
- the theme: `tools/static-site/zola/templates/`, `static/` or `theme.toml`;
- the template: `root.hcl` or `secrets-schema.json`;
- the CI: a `tools/github/workflows/*.yml`, or anything under
  `tools/github/scripts/` or `tools/github/policies/`;
- a dashboard set: a changed `*.json`;
- an observability stack or a plugin: anything but its README or CHANGELOG.

Anything else under `tools/` takes no label and tags nothing. `root-changelog.yml`'s
`releases` job copies every predicate to stand down for a releasing PR. Change
one copy and you change its twin (`noisypigeon/library#301`).

A failed garden generation shows up as a released version whose short URL
404s.

### Decision records

Records live at `tools/docs/adr/LIB-NNNN-<slug>.md`. This is also where the
spokes' decisions live: blog and garden are runway workloads, and their shims
hold no records (LIB-0017).

- **Older IDs stay valid and are never rewritten.**
  - `DEV-` records are archived verbatim in `tools/docs/adr/archive/`.
  - `COM-` and `RUN-` records survive as amendments whose headings carry the
    ID.
  - A bare `ADR-NNNN` in older prose is a `DEV-` alias, and `NPC-` is a `COM-`
    alias.
  - No new number is issued in any of those domains.
- **pigeon-cli is the exception.** It keeps its own `CLI-` records in its own
  `adr/` (LIB-0017 §5).
- **Filing one, by hand:**
  - The number is max+1 within `tools/docs/adr/`.
  - The file name and the H1 agree.
  - The author is always `Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).`
  - The sections are `## Context` / `## Decision` / `## Consequences` /
    `## Out of scope`, then optionally `## Verification`. There is no
    frontmatter and no index.
  - A change after filing goes under `## Amendments`, as a dated entry.
- **Out of scope.** A genuinely deferred item there gets an issue in runway,
  labelled `out-of-scope` (DEV-0031). A permanent design boundary doesn't.

### Runbooks

Operational procedures live at `tools/docs/runbooks/<slug>.md`, step by step,
each citing the record it serves:

- `restore-terraform-state-from-b2.md` (LIB-0007 §4);
- `release-a-stuck-state-lock.md` (LIB-0022 §4);
- `import-a-leaf-into-a-workload.md` (LIB-0032 §3).

## Terraform

- Leaves are `terraform/<provider>/<module>/<instance>/`. Each leaf calls one
  library module. Generated unit leaves are
  `workloads/<w>/<provider>/<module>/<instance>/` and
  `zones/<zone>/<provider>/<module>/<instance>/`.
- A leaf's path is its state key. Don't move one without a state move.
- **`root.hcl` is generated. Never edit it.** Bump `root_hcl_version`, run
  `mise run terraform-prepare` and commit the diff.
- State is on Scaleway, versioned in place, so there is no backup job.
- A Terraform PR is planned on the PR and applied by an owner's or
  collaborator's `terragrunt apply` comment. If it doesn't merge itself, merge
  it by hand once `terragrunt/apply` is green.
- One leaf reads another's value through a Terragrunt `dependency` block:
  - the upstream leaf declares an `output`;
  - the dependent passes `dependency.<name>.outputs.<output>` in `inputs`, and
    declares a matching `variable` (`sensitive` for a secret);
  - apply the upstream leaf first.
- A Grafana leaf must define `local.grafana_auth_token`.

## Commands

- `mise run plan` / `mise run apply` (prefer the PR flow)
- `mise run terraform-prepare`
- `mise run fmt-terraform` / `mise run fmt-check-terraform`
- `mise run secrets-edit <file>`
