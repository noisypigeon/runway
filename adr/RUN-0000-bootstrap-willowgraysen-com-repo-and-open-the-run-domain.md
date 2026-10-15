# RUN-0000: bootstrap the `willowgraysen.com` repo and open the `RUN-` ADR domain

- **Author**: Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).
- **Date**: 2026-10-15.
- **Status**: Accepted.

## Context

LIB-0001 §7 step 5 makes `willowgraysen.com` a spoke. LIB-0001 §Context noted
that until now it was "not a repo at all", only a directory in
`noisypigeon/noisypigeon`, yet it carries the domain's largest share of Terraform
and the family's heaviest module consumption. `pigeon.dev` (DEV-0162/0163) and
`noisypigeon.com` (COM-0001/0003) have each become spokes, and the
`terragrunt/root-hcl` template now covers this domain's providers as well
(`v1.1.0`, LIB-0003's second amendment). Nothing in the hub stands in the way.

This domain differs from the other two in three ways.

- **There is no website.** The domain's HTTPS endpoint is a Cloudflare redirect
  to `noisypigeon.com`. So there is no `web/`, no Pages deploy, and no
  blog-changelog. The repo is Terraform plus the workflows that serve it.
- **It is a namespace, not a site.** It holds `pigeon-cli`'s infrastructure and
  the data-ops projects' storage: the job and report buckets, the cluster,
  observability, and the cold buckets.
- **It is the most sensitive account in the family.** Its encrypted secrets
  include third-party storage credentials, and its buckets hold custodial and
  archival data.

## Decision

### 1. Create `noisypigeon/willowgraysen.com`, public

The repo was created public, like every other repo in the family. That was a
deliberate choice over private, and it accepts three costs:

- **Plan output becomes public.** Every Terraform PR posts its plan as a comment.
  CI masks decrypted secret *values*, but resource names, bucket names and the
  infrastructure's shape are visible.
- **The imported history becomes public in a second place.** It is already
  public in `noisypigeon`.
- **Its secrets share one age key with the rest of the family.**
  `terraform/secrets.enc` will use the same recipient as the other spokes, and
  this repo's `SOPS_AGE_KEY` holds the same key.

Private was considered and rejected. A ruleset on a private repository needs a
paid plan on a personal account, so the `terragrunt/apply` merge gate would have
been advisory there. Being public also keeps this repo identical in mechanism to
its siblings.

The mitigations are procedural and in-repo:

- `CLAUDE.md` opens with the sensitivity rules: everything pushed is public and
  permanent, no resource names in prose, read the whole plan before applying.
- ADRs here describe resources by role, not by name.
- The interaction limit in §4.
- RUN-0001 adds the comment-gated apply, restricted to OWNER, MEMBER and
  COLLABORATOR, and the `terragrunt/apply` ruleset.

### 2. Open `adr/` with `RUN-`-prefixed IDs

This repo's ADRs are `RUN-NNNN`, filed flat in `adr/` and numbered from `0000`
within it. `willowgraysen.com` is the namespace for `pigeon-cli` and the
data-ops projects: the things that *run*. A prefix taken from the domain name,
such as `WGC-`, would describe the repo's address rather than its purpose. The
convention is the one COM-0000 (filed as NPC-0000) and DEV-0160 established: a
new domain picks its own prefix and its own sequence.

### 3. The spoke's bootstrap: everything but the Terraform

This PR adds what every spoke has, minus anything to do with a website.

- **`fetch-lib.sh` and `.lib-version`.** `fetch-lib.sh` is `pigeon.dev`'s copy, the
  one exception to invariant 1. `.lib-version` is `workflows/v1.3.1`.
- **`.mise.toml`**: Terraform, Terragrunt and sops, plus the Terraform tasks
  RUN-0001 will use.
- **`.gitignore`**: Terraform working state, but not `root.hcl`, which LIB-0003
  requires a spoke to commit.
- **`root-changelog.yml`**, a thin caller of `spoke-root-changelog.yml`. The root
  `CHANGELOG.md` follows DEV-0160, and its header and marker arrived in the
  repo's single direct initial commit, since an empty repo has no base for a PR.
- **`interaction-limits-renew.yml`**, a thin caller of the hub's workflow,
  keeping the repo at `contributors_only`.
- **`CLAUDE.md` and `README.md`**.

The Terraform itself (the leaves, `root.hcl`, `spoke.hcl`, `.sops.yaml`,
`terraform/secrets.enc` and the Terragrunt callers) is RUN-0001, a separate
change. That follows LIB-0001 §7's "each step its own ADR" and keeps a
scaffolding PR from carrying live infrastructure.

### 4. Provisioning, recorded because no prior runbook had it

LIB-0002 found that a new repo's first workflow runs fail without this.

- **Repo secrets**, each holding the same value as `noisypigeon`'s:
  - `BOT_GITHUB_TOKEN` (changelog pushes);
  - `GH_ADMIN_TOKEN` (the interaction limit);
  - `SOPS_AGE_KEY` (decryption, from RUN-0001).
- **The bot account as a write collaborator**, invitation accepted, so its
  pushes to `main` succeed.
- **The interaction limit**, `contributors_only` for six months, applied once by
  dispatching `interaction-limits-renew.yml` and renewed monthly after that.
- **Merge commits stay enabled until RUN-0001's import merges,** to keep its
  history. They are disabled afterwards, as in DEV-0163 §6.

## Consequences

- **A fourth ADR domain.** Readers now meet `DEV-`, `COM-`, `LIB-` and `RUN-`.
  The hub's and the spokes' `CLAUDE.md` files list them all.
- **The sensitivity rules depend on discipline.** Nothing technical stops a
  resource name reaching a PR title or an issue. `CLAUDE.md` says so in its
  first section, but that is the only control.
- **The root changelog's first entries describe scaffolding,** not
  infrastructure, until RUN-0001 lands.

## Out of scope

- **The Terraform hoist.** RUN-0001.
- **A dedicated age key and credential rotation.** A permanent boundary for now:
  the shared key was chosen deliberately. The existing ciphertext already sits
  in `noisypigeon`'s public history under that key, so a dedicated key would
  protect only future values. Real isolation would mean rotating the underlying
  credentials too.
- **Further Actions hardening:** requiring approval of fork-PR workflows for all
  outside contributors, and read-only default token permissions. Both were
  considered and not applied. Fork PRs receive no secrets either way, and every
  workflow here declares its own permissions.

## Verification

1. `gh api repos/noisypigeon/willowgraysen.com -q .visibility` prints `public`.
2. `gh api repos/noisypigeon/willowgraysen.com/interaction-limits` shows
   `contributors_only`.
3. `gh secret list -R noisypigeon/willowgraysen.com` lists the three secrets.
4. This PR's merge writes exactly one root line through `spoke-root-changelog.yml`,
   which proves both `BOT_GITHUB_TOKEN` and the bot's write access.
5. `actionlint` passes on both workflows, and `shellcheck` on `fetch-lib.sh`.
