# LIB-0054: Redact identifiers from run comments, then rotate every secret

- **Author**: Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).
- **Date**: 2026-11-01.
- **Status**: Proposed. Extends LIB-0025 §4 and LIB-0026 §7, which mask
  secret values in run comments. It adds a rotation generation to the API key
  modules, beside LIB-0038 §2's `rotation_days`.

## Context

`terragrunt-run.yml` writes Terraform's output to `output.txt`, never to the
job log. `render-run-comments.js` turns that file into the PR's plan and apply
comments. Before it does, it replaces every value from the decrypted secrets
files with `***` (LIB-0025 §4). It masks values it was told about, and nothing
else.

**Identifiers get through.** An identifier is not a secret, so nothing masks
it:

- an apply prints each resource's ID as it creates it (`[id=…]`);
- a plan's refresh does the same;
- `Changes to Outputs` prints an output's `id`;
- a key's access key ID, an application's ID and a job definition's ID are
  all printed as they are created.

The rollout of LIB-0053 posted a new API key's access key ID in a public
comment this way.

CLAUDE.md already says never to paste key IDs or bucket names, so the
comments break the repo's own rule. They also cannot be taken back:

- everything pushed or posted here is public and permanent;
- GitHub keeps a public edit history for every comment;
- some earlier leaks were values, not just IDs: noisypigeon/runway#174 fixed a
  bucket output that wasn't marked sensitive, after it had planned.

So the fix has two halves:

1. stop new leaks at the one place they are written;
2. assume the old ones are out, and rotate every secret, so what leaked opens
   nothing.

Rotation goes second, so the new keys' IDs are never posted.

## Decision

### 1. `render-run-comments.js` redacts identifiers

A new step, `redactIdentifiers`, runs after `maskText` and before the output
is parsed into leaves. It runs on plan and apply comments alike, and on every
section, including the Terragrunt `Run` section.

It replaces each match with `(redacted)`, which reads like Terraform's own
`(sensitive value)`.

### 2. What counts as an identifier

It uses three rules.

**By attribute.** In a resource, data source or output block, it redacts the
value of an attribute:

- named `id`;
- ending in `_id` or `_ids`;
- or named `access_key`, `srn` or `arn`.

It handles both the plan form `name = "…"` and the output form
`"name" = "…"`, and every element of a list value.

**By progress line.** It redacts the `[id=…]` of any `Creating…`,
`Modifying…`, `Destroying…`, `… complete after …` or `Refreshing state…` line.

**By shape, anywhere in the text:**

- a UUID, with or without a region prefix (`fr-par/…`);
- a Scaleway access key ID: `SCW` and 17 upper-case letters or digits;
- a 32-character lower-case hex string, the shape of Cloudflare's zone,
  account and token IDs;
- a 24- or 25-character hex string, the shape of a Backblaze application key
  ID.

**Bucket names.** The `name` and `bucket` attributes of any resource whose
type names a bucket are redacted, as CLAUDE.md asks.

**What stays,** so a plan is still worth reading:

- every action, address and leaf path;
- every attribute name;
- every value that identifies nothing, such as sizes, images, schedules,
  permission sets and the names of resources other than buckets.

### 3. It fails closed

After redaction, a last check scans each comment body for the shape rules.

- **If anything survives,** that leaf's detail is withheld, and replaced
  with: `(withheld: an identifier survived redaction; the encrypted plan
  artifact holds the full output)`.
- **The summary row** says the detail was withheld, and the run warns.

A missed pattern costs a plan's detail, never a leak.

`render-run-comments.test.js` covers each rule, using synthetic output in
`testdata/` with made-up identifiers of each shape. It also covers
the fail-closed path.

### 4. Nothing else prints them

- **`output.txt` stays out of the job log.** `scripts-test` fails if
  `terragrunt-run.yml` ever prints it.
- **The reusable workflows' own `echo` lines print no identifier.**
  `scaleway-job-run.yml` stops printing its run's ID, and says only that a
  run started and how it ended.
- **The plan archive is unchanged.** `plan-archive.sh` encrypts it to the
  spoke's age key, and it is where the full output lives.

### 5. The history is swept

A one-off runway workflow, `scrub-run-comments.yml` (`workflow_dispatch`),
runs a library script over every PR.

- **It deletes every detail comment** that `github-actions[bot]` posted, which
  is each `<!-- terragrunt-plan -->` or `<!-- terragrunt-apply -->` comment
  marked `<!-- part -->`.
- **It deletes rather than edits,** because an edited comment keeps its old
  text in its public history.
- **It keeps the summary comments.** They hold only leaf paths, counts and
  links, which the repo already shows.
- **It reports a count only.** It prints how many comments it deleted, and
  nothing of what was in them.

The PR's diff stays the record of what changed. Old detail was only ever a
convenience, and it expired with its artifact.

### 6. Every secret is rotated, after §§1–5 ship

Rotation goes in this order. Each step must pass before the next starts.

1. **The sops age key.**
   - Add a new recipient to `.config/sops.yaml`.
   - Run `sops updatekeys` over every encrypted file, swap `SOPS_AGE_KEY`,
     then remove the old recipient and re-run `updatekeys`.
   - This goes first, so every value rotated after it is encrypted only to
     the new key. The old key still opens git history, which by then holds
     only dead values.
2. **Every Terraform-managed key.**
   - **What it covers:** each workload's and zone's deployer key; the
     job-runner and self-delete keys; and the Cloudflare tokens and Backblaze
     keys the spoke creates.
   - **The mechanism:** `scaleway/iam-api-key`, `cloudflare/api-token` and
     `backblaze/api-key` gain a `rotation_generation` input. It is a number,
     default `0`, folded into `terraform_data.rotation`'s input, so changing
     it replaces the key, creating the new one before destroying the old.
   - **How it's set:** `root.hcl` passes a spoke-wide `rotation_generation`
     from `.config/spoke.hcl` to every key kind, and an entry can override it.
     One bump rotates every managed key in one reviewed PR, with no
     hand-typed `-replace`.
   - **Order:** staged applies (LIB-0024) take care of it, because a
     deployer's dependents read its new key from its outputs.
   - **A canary first:** it runs on one zone before the rest.
3. **The hand-made secrets** in `terraform/secrets/`:
   - **What they are:** the spoke's Scaleway key, the Cloudflare and Backblaze
     keys and their break-glass pairs, and the shared environment values.
   - **How:** each is rotated at its provider and saved with
     `mise run secrets-edit`. A plan of everything should then show
     `No changes.`, signed in with the new values.
   - **Break-glass:** each pair is rotated on a different day from its
     primary, so one credential in each pair is always known good (LIB-0014).
4. **The GitHub secrets:** the bot token, the admin token and the crate
   registry token. Each is regenerated, replaced, and its old one revoked.
5. **Workload secrets** in `secrets.workload.yaml`: each is rotated at its
   source and saved with `mise run secrets-edit`.

A step is done when the provider no longer lists the old credential, and a
plan of every unit shows `No changes.`

### 7. A runbook holds the steps

`tools/docs/runbooks/rotate-all-secrets.md` gives the step-by-step for §6,
citing this record. It names each credential by role, and lists the places
outside Terraform that hold a copy and must be updated, such as pigeon-cli's
runtime configuration and a laptop's CLI profile. This record holds the
rules.

## Consequences

- **A comment shows what changes, not what it's called.** Reading a plan
  still tells an owner every action and every non-identifying value.
- **A redaction miss withholds detail rather than leaking it.** The full
  output stays in the encrypted artifact.
- **Old detail comments are gone.** Summaries and diffs remain.
- **Rotation is a PR.** After this, rotating every managed key is a
  one-line bump, reviewed through its plan like any other change.
- **Rotation breaks any copy kept outside Terraform.** The runbook lists
  them, and each must be updated in the same sitting.

## Out of scope

- **Secrets committed to git history,** as opposed to posted in comments.
  `check-secrets.sh` already guards new commits. A full history scan is
  deferred, and gets an `out-of-scope` issue.
- **Scheduled rotation for every key.** `rotation_days` already exists per
  kind. Turning it on by default is a separate decision, deferred, with an
  `out-of-scope` issue.
- **Redacting CI logs of runs that already happened.** Run logs expire on
  GitHub's retention. Deleting them early is something the owner can do by
  hand, and is not automated here.

## Verification

1. **Tests:** `render-run-comments.test.js` passes, with every rule and the
   fail-closed path covered.
2. **A fresh apply that creates a key** posts no ID, access key ID, SRN or
   bucket name, and still shows each action.
3. **After the sweep,** no `github-actions[bot]` detail comment remains on
   any PR.
4. **After rotation:**
   - each provider lists only the new credentials;
   - a plan of every unit shows `No changes.`;
   - a run of `run-scaleway-job` with `job=version` succeeds, signed in with
     the new job-runner key.
