# CLAUDE.md

This is `noisypigeon/willowgraysen`: the Terraform for `willowgraysen.com`, the namespace that holds `pigeon-cli`'s and the
data-ops projects' infrastructure. **There is no website** — the domain's HTTPS endpoint is a
Cloudflare redirect to `noisypigeon.com`, which the `noisypigeon/blog` repo runs (COM-0006). It is a **spoke** in LIB-0001's hub-and-spoke
architecture: infrastructure only, consuming every reusable asset from `noisypigeon/pigeon-lib` by
pinned version (RUN-0000).

This document describes the tree as it is now. Edit it in place when the tree changes — it is not
a history. `CHANGELOG.md` is the history.

## This is the most sensitive repo in the family — read this first

The account behind it holds custodial and archival data and third-party storage credentials. The
repo is **public** (RUN-0000 records why and what that accepts), so:

- **Everything pushed here is permanent and public** — commits, branch names, PR titles and
  bodies, issue text, and CI logs. Treat anything you write as published.
- **Never paste plan output, bucket names, key IDs, or `secrets.enc` contents** into an issue, a
  PR body, a commit message, or a doc. CI masks decrypted secret *values* in its logs and PR
  comments; it cannot mask what you type.
- **Never decrypt `terraform/secrets.enc` to a file.** `mise run secrets-edit` edits it in place;
  `root.hcl` decrypts it in memory. Never commit a plaintext `.env`.
- **Read the whole plan before commenting `terragrunt apply`.** An apply that destroys a cold
  bucket is not recoverable.
- **Interactions are limited to prior contributors** (`interaction-limits-renew.yml`).

## Layout

```
CHANGELOG.md                    one line per merged PR, by CI -- see "Changelog"
.lib-version                    the pigeon-lib ref everything below consumes
.mise.toml                      terraform/terragrunt/sops versions and tasks
.sops.yaml                      sops/age recipient for terraform/secrets.enc
fetch-lib.sh                    clones pigeon-lib into .lib-src/ at /.lib-version
root.hcl                        GENERATED Terragrunt root -- see "Terraform"; never edit
spoke.hcl                       root.hcl template version + this spoke's instance values
terraform/                      the domain's Terraform leaves -- see "Terraform"
  secrets.enc                   sops/age-encrypted dotenv
adr/                            decision records, RUN-NNNN -- see "Decision records"
.github/workflows/              thin callers into pigeon-lib -- see "CI"
```

`/.lib-src/` and every `.terragrunt-cache/` are generated and gitignored. `root.hcl` is generated
too, but committed — see "Terraform".

## Where the dependencies are

**Nothing is vendored in this repo.**

| What | Where | How it gets here |
| --- | --- | --- |
| Terraform 1.16.3, Terragrunt 1.1.6, sops 3.13.3 | pinned in `.mise.toml` | `mise install` |
| CI job bodies | `noisypigeon/pigeon-lib`, at `.github/workflows/` | reusable workflows, called at the `workflows/vX.Y.Z` tag `/.lib-version` names |
| `root-changelog.sh`, `resolve-root-hcl.sh` | `noisypigeon/pigeon-lib`, at `.github/scripts/` | run out of `/.lib-src/`, which `fetch-lib.sh` materializes |
| Terraform modules | `noisypigeon/pigeon-lib`, at `terraform/` | `source = "https://noisypigeon.garden/terraform/<provider>/<module>/vX.Y.Z"` |
| Terragrunt `root.hcl` | `noisypigeon/pigeon-lib`, at `terragrunt/root-hcl/` | `resolve-root-hcl.sh` copies it at the version `spoke.hcl` pins; committed here |

`/.lib-version` decides which library code runs; bump it, and the `@workflows/…` refs in every
caller, to take a hub change — never track a branch (LIB-0001 invariant 2). To change a module, the
CI, or any script, send a PR to `noisypigeon/pigeon-lib`, then bump the pin here. For local
iteration across both, point `LIB_SRC` at a `pigeon-lib` checkout and `fetch-lib.sh` leaves it
alone. `fetch-lib.sh` is the one script this repo keeps — a spoke cannot fetch its own fetcher.

## Terraform

`terraform/` holds eighteen leaves laid out as `terraform/<provider>/<module>/<instance>/`, where
`<provider>/<module>` is exactly the pigeon-lib module the leaf calls and each leaf calls one
(LIB-0004). They were hoisted from `noisypigeon/noisypigeon` with their history (RUN-0001) and
re-laid-out with state moves (LIB-0004, #314). `root.hcl` sits at this repo's root, so each leaf's
state key is `terraform/<leaf path>/terraform.tfstate` in this domain's own bucket (LIB-0001
invariant 4). **Moving `root.hcl` or a leaf changes its state key** — don't, without a state-move
runbook (LIB-0004 §3; DEV-0106).

- **`backblaze/bucket/*`** — B2 cold-storage buckets. **Custodial and archival data: destroying one
  is unrecoverable.** They get the Backblaze provider from `spoke.hcl`'s `providers` map.
  Their keys are commented out in place; enabling one means a new `backblaze/api-key/<name>` leaf.
- **`scaleway/object-bucket/*`** — `pigeon-cli`'s per-job and per-phase report buckets, and this
  domain's Terraform state bucket (`terraform-state`).
- **`scaleway/iam-application/pigeon-cli`, `scaleway/cockpit-observability/pigeon-cli`,
  `scaleway/pigeon-cluster/pigeon-cli`** — the CLI's shared IAM application, its observability, and
  its job cluster (whose module is currently commented out).
- **`scaleway/{iam-policy,iam-api-key}/pigeon-deduplicate-local-key`** — a scoped key for running
  the deduplicate phase locally. Its outputs are sensitive; never print them.
- **`scaleway/{iam-application,iam-policy,iam-api-key}/pigeon-cli-grafana`,
  `grafana/dashboard/pigeon-cli`** — the identity and dashboards for pigeon-cli's managed
  Grafana. The dashboard JSON is not here: it is versioned in pigeon-lib's
  `grafana-dashboards/pigeon-cli` track and fetched by its tag URL.
- **`scaleway/project/com`** — the Scaleway project.

Where one leaf needs another's value, it reads it with a Terragrunt `dependency` block, which reads
the upstream leaf's **outputs from state**: the upstream leaf declares an `output`, the dependent
passes `dependency.<name>.outputs.<output>` as an `inputs` entry and declares a matching
`variable` (marked `sensitive` for a secret). The `pigeon-cli-grafana` leaves are the example —
policy, key and dashboard depend on the application's `id`, and the dashboard leaf on the key's
`secret_key`. A brand-new upstream leaf must be applied before its dependents can plan, and a
leaf whose state arrived by a state move needs a refresh-only apply to record its outputs.

Mechanics, the same as the other spokes:

- **`root.hcl` is generated — never edit it.** It is pigeon-lib's `terragrunt/root-hcl` template at
  the version `spoke.hcl` pins (`root_hcl_version`), copied by
  `.lib-src/.github/scripts/resolve-root-hcl.sh` and committed, because Terragrunt's git filter
  plans inside git worktrees, which only hold tracked files (LIB-0003). CI runs the resolver with
  `--check` and fails on drift. To take a template change, bump `root_hcl_version`, run
  `mise run terraform-prepare`, commit the diff.
- **`spoke.hcl`** holds the template version, `state_bucket_secret`
  (`WILLOWGRAYSEN_COM_TERRAFORM_STATE_BUCKET_NAME`) and the `providers` map (LIB-0005).
  `scaleway` is on for every leaf, and `cloudflare` is off: its two leaves moved to
  `noisypigeon/blog` (COM-0006); `backblaze` and `grafana` only for the leaves
  under their `leaves` prefixes. A Grafana leaf must define `local.grafana_auth_token`, the Cockpit
  API key secret the generated provider authenticates with.
- **Secrets** are in `terraform/secrets.enc` (sops/age, dotenv; `.sops.yaml` has the recipient).
  Edit with `mise run secrets-edit` — never decrypt to a file. CI decrypts with `SOPS_AGE_KEY`.
- **`state/iam` is not here.** It mints the deploy key these leaves authenticate with, and must not
  depend on that key, so it stays in `noisypigeon/noisypigeon` on that repo's shared root and
  shared state bucket (LIB-0001 §8; DEV-0133; RUN-0001). Rotating the deploy key is a PR *there*,
  then a `secrets-edit` here.

A Terraform PR is planned by `terragrunt-plan.yml` and applied by commenting `terragrunt apply` on it
(`terragrunt-apply.yml`; ADR-0124/0129) — only an OWNER, MEMBER or COLLABORATOR's comment counts. A
successful apply sets the `terragrunt/apply` status `main`'s ruleset requires; its auto-merge
currently fails (noisypigeon/noisypigeon#310), so merge by hand once the status is green. Never merge
a Terraform PR any other way. **The plan comment is public** — CI masks secret values, not names.

## Changelog

`CHANGELOG.md` is **generated — do not hand-edit it.** This is DEV-0160's contract, adopted by
RUN-0000: exactly one line per merged PR, every PR, written by `root-changelog.yml` as
`- [<tag>] <PR title> ([#N](url))` under a `## YYYY-MM-DD` heading. The tag is the first match of
`terraform/`/`root.hcl`/`spoke.hcl`/`.sops.yaml` → `terraform`, `adr/` → `adr`, `.github/` → `ci`,
else `repo`. The `<!-- entries below; newest first -->` marker is where entries go; the script
refuses to write without it. **PR titles are published** — keep resource names out of them.

## CI

All workflows are thin callers into `pigeon-lib`, so **that is where their behavior is defined.**

- `root-changelog.yml` → `spoke-root-changelog.yml`, passing this repo's tag precedence, in its own
  `main-writer-rollup` concurrency group. Pushes with `BOT_GITHUB_TOKEN`, so the bot account needs
  write access here.
- `interaction-limits-renew.yml` → `interaction-limits-renew.yml`, monthly, re-applying a
  `contributors_only` interaction limit. Needs `GH_ADMIN_TOKEN`.
- `terragrunt-plan.yml` / `terragrunt-apply.yml` → `terragrunt-detect.yml` and `terragrunt-run.yml`;
  see "Terraform" above.

`main` has a ruleset (RUN-0001, copied from `noisypigeon`'s ADR-0129): no force-push, and the
`terragrunt/apply` status is required — the detect job sets it to success straight away for a PR
touching no Terraform.

This repo cuts no releases and has no `release:*` labels; every versioned asset is in
`pigeon-lib`. A change spanning the hub and this repo is two PRs, hub first, then a pin bump.

## Commits and PRs

[Conventional Commits](https://www.conventionalcommits.org/), with an optional scope and the PR
number appended by squash merge: `fix(terraform): … (#12)`. There is no human reviewer.

## Decision records

This repo's ADRs live flat in `adr/`, as `RUN-NNNN-<slug>.md`, numbered from `0000` within that
directory. `RUN-0000` opened the domain and bootstrapped this repo; `RUN-0001` hoisted
the Terraform here. Read them before changing the
Terraform layout, the CI wiring, or the repo's settings; if a change would contradict one, write a
new ADR rather than silently diverging.

`RUN-` is this domain's prefix because `willowgraysen.com` is the namespace for `pigeon-cli` and the
data-ops projects — the things that *run* — not for a website (RUN-0000).

Filing one, by hand:

- **Number**: max+1 within `adr/`.
- **Filename and H1 agree**: `RUN-0002-<slug>.md` holds `# RUN-0002: <title>`.
- **Author is always** `Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).`
- **Sections**: `## Context` / `## Decision` / `## Consequences` / `## Out of scope`, optionally
  then `## Verification`. No YAML frontmatter, and no index.
- Cite `RUN-NNNN` for this domain, `LIB-NNNN` for `pigeon-lib`'s, `DEV-NNNN` for `noisypigeon/garden`'s
  and `COM-NNNN` for `noisypigeon/blog`'s. Bare `ADR-NNNN` in older prose means the `DEV-` corpus.
- Genuinely-deferred `## Out of scope` items get a GitHub issue against `noisypigeon/noisypigeon`
  (ADR-0031); permanent design boundaries do not.
- **An ADR here is public, too.** Describe resources by role ("the cold buckets"), not by name.

House style: state findings as facts verified against the live tree rather than against prior
prose; say plainly what a decision reverses; classify every `## Out of scope` bullet as either a
permanent boundary or genuinely deferred; and in `## Consequences`, name concrete costs rather than
restating the benefits.
