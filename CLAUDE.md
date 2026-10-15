# CLAUDE.md

This is `willowgraysen.com`: the Terraform for the namespace that holds `pigeon-cli`'s and the
data-ops projects' infrastructure. **There is no website** — the domain's HTTPS endpoint is a
Cloudflare redirect to `noisypigeon.com`. It is a **spoke** in LIB-0001's hub-and-spoke
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
fetch-lib.sh                    clones pigeon-lib into .lib-src/ at /.lib-version
adr/                            decision records, RUN-NNNN -- see "Decision records"
.github/workflows/              thin callers into pigeon-lib -- see "CI"
```

`/.lib-src/` and every `.terragrunt-cache/` are generated and gitignored. The Terraform leaves,
`root.hcl`, `spoke.hcl`, `.sops.yaml` and `terraform/secrets.enc` arrive with RUN-0001.

## Where the dependencies are

**Nothing is vendored in this repo.**

| What | Where | How it gets here |
| --- | --- | --- |
| Terraform 1.16.3, Terragrunt 1.1.6, sops 3.13.3 | pinned in `.mise.toml` | `mise install` |
| CI job bodies | `noisypigeon/pigeon-lib`, at `.github/workflows/` | reusable workflows, called at the `workflows/vX.Y.Z` tag `/.lib-version` names |
| `root-changelog.sh`, `resolve-root-hcl.sh` | `noisypigeon/pigeon-lib`, at `.github/scripts/` | run out of `/.lib-src/`, which `fetch-lib.sh` materializes |
| Terraform modules | `noisypigeon/pigeon-lib`, at `terraform/` | `source = "https://pigeon.dev/modules/<provider>/<module>/vX.Y.Z"` |

`/.lib-version` decides which library code runs; bump it, and the `@workflows/…` refs in every
caller, to take a hub change — never track a branch (LIB-0001 invariant 2). To change a module, the
CI, or any script, send a PR to `noisypigeon/pigeon-lib`, then bump the pin here. For local
iteration across both, point `LIB_SRC` at a `pigeon-lib` checkout and `fetch-lib.sh` leaves it
alone. `fetch-lib.sh` is the one script this repo keeps — a spoke cannot fetch its own fetcher.

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

This repo cuts no releases and has no `release:*` labels; every versioned asset is in
`pigeon-lib`. A change spanning the hub and this repo is two PRs, hub first, then a pin bump.

## Commits and PRs

[Conventional Commits](https://www.conventionalcommits.org/), with an optional scope and the PR
number appended by squash merge: `fix(terraform): … (#12)`. There is no human reviewer.

## Decision records

This repo's ADRs live flat in `adr/`, as `RUN-NNNN-<slug>.md`, numbered from `0000` within that
directory. `RUN-0000` opened the domain and bootstrapped this repo. Read them before changing the
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
- Cite `RUN-NNNN` for this domain, `LIB-NNNN` for `pigeon-lib`'s, `DEV-NNNN` for `pigeon.dev`'s
  and `COM-NNNN` for `noisypigeon.com`'s. Bare `ADR-NNNN` in older prose means the `DEV-` corpus.
- Genuinely-deferred `## Out of scope` items get a GitHub issue against `noisypigeon/noisypigeon`
  (ADR-0031); permanent design boundaries do not.
- **An ADR here is public, too.** Describe resources by role ("the cold buckets"), not by name.

House style: state findings as facts verified against the live tree rather than against prior
prose; say plainly what a decision reverses; classify every `## Out of scope` bullet as either a
permanent boundary or genuinely deferred; and in `## Consequences`, name concrete costs rather than
restating the benefits.
