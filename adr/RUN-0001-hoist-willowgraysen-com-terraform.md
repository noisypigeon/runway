# RUN-0001: hoist `willowgraysen.com`'s Terraform into this repo, leaving `state/iam` behind

- **Author**: Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).
- **Date**: 2026-10-15.
- **Status**: Accepted.

## Context

RUN-0000 created this repo as a Terraform-only spoke and deferred the Terraform
to this record. This is the second half of LIB-0001 §7 step 5, and the last of
the three domain hoists, after DEV-0163 (`pigeon.dev`) and COM-0003
(`noisypigeon.com`).

Checked against `noisypigeon/noisypigeon@219706e`, this domain has fifteen
leaves under `willowgraysen.com/terraform/`.

- **Fourteen include `willowgraysen.com/root.hcl`** through
  `find_in_parent_folders`, read `willowgraysen.com/secrets.enc`, and keep state
  in this domain's own bucket (ADR-0133) under
  `${path_relative_to_include()}/terraform.tfstate`.
- **`state/iam` includes `${get_repo_root()}/root.hcl`,** the monorepo's shared
  root. It mints the deploy key the other fourteen use. That is LIB-0001 §8,
  tracked as noisypigeon/noisypigeon#308.

This domain's root was the one the template could not yet express. It adds a
`grafana` provider requirement and DEV-0148's latent Backblaze mechanism, which
the `cold/*` leaves turn on. `terragrunt/root-hcl/v1.1.0` (pigeon-lib#21) added
both as optional `spoke.hcl` settings. No leaf reads another leaf's state.
`pigeon-cli/shared/grafana` reads its dashboard JSON through `fileset()` and
`file()`, which `terragrunt-run.yml`'s per-directory filter already covers
(ADR-0138).

## Decision

### 1. `state/iam` stays in `noisypigeon` (LIB-0001 §8, option 1)

This is the same choice DEV-0163 §1 and COM-0003 §1 made, for the same reasons,
and with more weight here. The alternative was a bootstrap root, which would put
the organisation-level shared deployer credentials into this, the most sensitive
repo. All three spokes have now chosen option 1, which settles #308.

### 2. The other fourteen move with their history, and their state does not move

The leaves were imported with one `git filter-repo` pass over a fresh clone of
`noisypigeon`.

- **Kept:** this domain's own paths, `willowgraysen.com/` and
  `workloads/willowgraysen.com/`.
- **Renamed:** `…/terraform/` → `terraform/` and `…/secrets.enc` →
  `terraform/secrets.enc`.
- **Dropped:** `terraform/state/iam/`. Tags were dropped before filtering.

The result was 52 files and 26 commits, back to noisypigeon#209 (ADR-0133). It
was merged with `--allow-unrelated-histories`. The imported tree is
byte-identical to the source, `secrets.enc` included.

**State does not move.** Every key stays `terraform/<leaf>/terraform.tfstate` in
the bucket named by `WILLOWGRAYSEN_COM_TERRAFORM_STATE_BUCKET_NAME`:

| Group | Leaf | Key in `noisypigeon` and here |
| --- | --- | --- |
| cold storage | `cold/custodial-duck-jellyfish` | `terraform/cold/custodial-duck-jellyfish/terraform.tfstate` |
| cold storage | `cold/deduplicated-misc` | `terraform/cold/deduplicated-misc/terraform.tfstate` |
| cold storage | `cold/snapshot-2026-10-09` | `terraform/cold/snapshot-2026-10-09/terraform.tfstate` |
| pigeon-cli | `pigeon-cli/bucket/pigeon/deduplicate` | `terraform/pigeon-cli/bucket/pigeon/deduplicate/terraform.tfstate` |
| pigeon-cli | `pigeon-cli/bucket/pigeon/transform` | `terraform/pigeon-cli/bucket/pigeon/transform/terraform.tfstate` |
| pigeon-cli | `pigeon-cli/cluster` | `terraform/pigeon-cli/cluster/terraform.tfstate` |
| pigeon-cli | `pigeon-cli/shared/cockpit` | `terraform/pigeon-cli/shared/cockpit/terraform.tfstate` |
| pigeon-cli | `pigeon-cli/shared/grafana` | `terraform/pigeon-cli/shared/grafana/terraform.tfstate` |
| pigeon-cli | `pigeon-cli/shared/iam-application` | `terraform/pigeon-cli/shared/iam-application/terraform.tfstate` |
| pigeon-cli | `pigeon-cli/shared/reports/phase-deduplicate` | `terraform/pigeon-cli/shared/reports/phase-deduplicate/terraform.tfstate` |
| pigeon-cli | `pigeon-cli/shared/reports/phase-transform` | `terraform/pigeon-cli/shared/reports/phase-transform/terraform.tfstate` |
| domain | `redirect/dns` | `terraform/redirect/dns/terraform.tfstate` |
| domain | `project` | `terraform/project/terraform.tfstate` |
| domain | `state/bucket` | `terraform/state/bucket/terraform.tfstate` |

These paths are already public in `noisypigeon`'s tree. This table adds no
names.

### 3. `root.hcl` comes from template `v1.1.0`, committed

`spoke.hcl` pins `root_hcl_version = "1.1.0"` and sets
`state_bucket_secret = "WILLOWGRAYSEN_COM_TERRAFORM_STATE_BUCKET_NAME"`,
`backblaze = true`, and a `grafana` entry in `extra_required_providers`.

`root.hcl` is generated from the template and committed, as in LIB-0003's
amendment. CI checks it with `--check`.

Each of the fourteen leaves was rendered with `terragrunt render --format=json`
under `willowgraysen.com/root.hcl` and under the template. Each differs in one
key, the generated provider file's `contents`, and only in whitespace: the old
root emitted a blank indented line where its Backblaze entry would go. The
Backblaze provider file and every state key match exactly.

### 4. CI, tooling and the merge gate

- **`terragrunt-plan.yml` and `terragrunt-apply.yml`** are copied from
  `noisypigeon.com`'s (COM-0003 §4):
  - the same `leaf_pattern`;
  - `secrets_files: terraform/secrets.enc`;
  - a `prepare_cmd` that fetches the library and runs `--check`.

  The apply is gated on a fixed comment from an OWNER, MEMBER or COLLABORATOR.
- **`.sops.yaml`** has one rule, `^terraform/secrets\.enc$`, with the shared
  recipient (RUN-0000 §1).
- **`main` gets `noisypigeon`'s ruleset (ADR-0129):** no force-push, and a
  required `terragrunt/apply` status, with the owner and the bot as bypass
  actors. It is created after this record's PR merges.
- **Merge commits are disabled** once this PR, which needs one, has merged.

### 5. Removing the leaves from `noisypigeon` is never applied

The `noisypigeon` PR that deletes the fourteen leaves, `willowgraysen.com/root.hcl`
and `willowgraysen.com/secrets.enc` **will plan destroys** against the bucket and
keys this repo now owns.

**Applying it would destroy the cold-storage buckets, whose contents are custodial
and unrecoverable,** along with:

- the `pigeon-cli` job and report buckets;
- the observability stack and the IAM application;
- the redirect;
- the project and the state bucket.

That PR merges through the ruleset's owner bypass, and `terragrunt apply` is
never commented on it. DEV-0130's "empty the old location's state" must not be
followed here, because the old location and the new one are the same object
(DEV-0163 §5).

### 6. One leaf's state was ahead of its config, and is caught up rather than destroyed

`pigeon-cli/bucket/pigeon/deduplicate`'s state held three resources that no
committed config described. A worktree that was never committed had applied
them, and a locally running deduplicate job is using the key:

- an IAM policy granting Object Storage access on this project to `pigeon-cli`'s
  shared IAM application;
- an API key for that application;
- the key's `time_static` creation timestamp.

Planned against the committed config, all three were orphans scheduled for
**destruction**. That would have revoked the running job's credentials.

The fix is configuration, not an `import`, because the resources were already in
state. The leaf gains `iam.tf` (`iam-policy/v4.0.0` and `iam-api-key/v0.2.0`)
and `outputs.tf` (the key's `access_key` and `secret_key`, sensitive). It plans
`No changes.`, which proves the config describes exactly what exists.

The application and project are taken from the existing
`ENV_SW_PIGEON_CLI_IAM_APPLICATION_ID` and `SCALEWAY_PROJECT_ID` secrets, so no
identifier is written into this public repo. The key expires 30 days after its
creation, the module's default. Renewing it is a replace of `module.iam_api_key`.

The same plan had been failing in CI with
`scaleway-sdk-go: denied authentication: invalid API key format or empty value`.
With the config added, it no longer fails.

## Consequences

- **This repo now holds the family's most valuable infrastructure.** The apply
  gate, the ruleset and the interaction limit are the technical controls. The
  rules at the top of `CLAUDE.md` are the procedural one.
- **Every Terraform PR publishes its plan,** with values masked but resource
  structure visible. This is the cost RUN-0000 §1 accepted.
- **Applying is a hand merge until #310 is fixed.**
- **`noisypigeon` now runs only three `state/iam` leaves,** one per domain, on
  the shared root, `.env.enc` and the shared bucket. LIB-0001 step 6 inherits
  exactly that.

## Out of scope

- **Hoisting `state/iam`.** A permanent boundary for this spoke, per §1.
- **The `willowgraysen.com` → `noisypigeon.com` redirect's documentation.**
  Genuinely deferred, tracked as noisypigeon/noisypigeon#309. The leaf now lives
  here, in `terraform/redirect/dns`.
- **Re-enabling the `pigeon-cli/cluster` module.** That is `pigeon-cli`'s
  decision; it moves as it was.
- **Credential rotation or a dedicated age key.** RUN-0000's permanent boundary.

## Verification

1. **The template is equivalent,** per the renders in §3.
2. **The import is exact.** `diff -rq` against
   `noisypigeon@219706e:willowgraysen.com/terraform/` differs only in
   `secrets.enc`'s location and the excluded `state/iam/`, `cmp` of the two
   `secrets.enc` files is silent, and the repo has no tags.
3. **The plan is a no-op apart from earlier drift:**
   - `No changes.` on thirteen leaves, locally (using `terragrunt-run.yml`'s exact
     filter construction) and in this PR's CI. That includes `deduplicate`, after
     §6.
   - `pigeon-cli/shared/grafana` plans one in-place update to the `overview`
     dashboard. It plans identically under the monorepo's layout, so the hoist
     did not cause it, and it is left for its own PR.
   - No leaf plans a destroy.
4. **After `noisypigeon`'s deletion merges:**
   - `willowgraysen.com/terraform/state/iam` plans clean there.
   - `https://willowgraysen.com` still redirects to `noisypigeon.com`.
   - `mise run plan` here shows `No changes.` on all fourteen leaves.
   - A trivial Terraform PR here is planned, applied and gated.
