# LIB-0053: Scaleway Serverless Jobs, for ad-hoc and recurring jobs

- **Author**: Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).
- **Date**: 2026-11-01.
- **Status**: Proposed. Extends LIB-0023's kind table and LIB-0043's compute
  kinds. Keeps LIB-0019: the image is the one pigeon-cli already publishes.

## Context

pigeon-cli's work comes in two shapes:

- **ad-hoc jobs**, run once by hand, such as a backfill or a one-off
  transform;
- **recurring jobs**, run on a schedule, such as a nightly report.

Each runs its image, does its work against the data-ops buckets, and exits.
What runs them today:

- **The Kapsule job cluster** (`terraform/scaleway/compute-cluster/`) is
  always on, and is billed whether or not anything runs.
- **A self-deleting instance** (LIB-0043 §3) runs once and removes itself.
  But it is a VM:
  - it needs cloud-init, a keyring and a self-delete key;
  - it takes minutes to boot;
  - it has no schedule of its own.

**What fits instead.** Scaleway Serverless Jobs run a container image to
completion:
- a run starts in seconds and leaves nothing behind;
- a job definition costs nothing between runs;
- a definition can carry a cron, so Scaleway itself starts its runs on
  schedule.

LIB-0019 already publishes a pigeon-cli image to ghcr.io for each release, so
nothing new needs building.

## Decision

### 1. A workload kind, `scaleway.job.<k>`

| YAML key | Module | Shape | Instance | Credentials | State |
| --- | --- | --- | --- | --- | --- |
| `scaleway.job.<k>` | `scaleway/job-definition` (new) | map | `<k>` | workload | workload |

- **It is a workload unit's kind alone**, like LIB-0043's compute kinds.
- **The name defaults** to `<prefix>-<suffix><tag>-<k>`.
- **Wiring:** `project_id` comes from the project. An entry can't set it.

### 2. An entry

| Key | Type, default | Becomes |
| --- | --- | --- |
| `image` | string, required | `image_uri`. It must name a pinned tag or digest, never `latest` or a bare name |
| `command` | list of strings, optional | `startup_command`, overriding the image's entrypoint |
| `args` | list of strings, optional | `args` |
| `cpu` | mvCPU, default `1000` | `cpu_limit` |
| `memory` | MB, default `2048` | `memory_limit` |
| `storage` | MiB, default `10240` | `local_storage_capacity` |
| `timeout` | Go duration, default `"1h"` | `timeout` |
| `schedule` | cron string, optional | the definition's `cron.schedule` |
| `timezone` | TZ name, default `"Europe/London"` | `cron.timezone`, only with `schedule` |
| `env` | map, default `{}` | `env` for plain values; a Secret Manager reference for a `secretRef` (§3) |

- **A job with `schedule` is recurring.** Scaleway starts its runs, and
  nothing in GitHub does.
- **A job without one is ad hoc.** It runs only when dispatched (§5).
- **Both are the same definition,** so a recurring job can also be run by
  hand.

### 3. Secrets go to Secret Manager

An `env` value of `{secretRef: NAME}` names a value in the workload's
`secrets.workload.yaml` (LIB-0025).

- **The module creates one `scaleway_secret` and version per referenced
  name.** The definition maps each one into its environment with
  `secret_reference { secret_id, secret_version, environment }`.
- **No secret sits in the definition's plain env,** or in what the console
  shows of it.
- **This is a small exception to LIB-0038's single-resource rule.** The module
  wraps a definition plus the secrets only it reads. They have no life apart
  from the job, so splitting them into kinds of their own would only add
  wiring.

### 4. The job's own credentials

A job that reaches the workload's buckets uses one of the workload's
`scaleway.iam.apiKey` entries. The entry's env names the key's access and
secret key, which the generator wires as secret references, as LIB-0043 §4
wires an instance's keyring. There is no new IAM kind: a job gets the same
scoped key an instance would.

### 5. Ad-hoc runs go through a reusable workflow

`scaleway-job-run.yml` (`github/workflows`) runs one job once.

- **Inputs:** `workload`, `job`, and optional `args` and `env` overrides for
  that run.
- **It reads its key** from the `job-runner` key's state (§6) with
  `terragrunt output -json module`, as `site-r2.yml` reads its deploy token.
  It adds no GitHub secret.
- **It starts one run** of the definition through the Serverless Jobs API,
  with the overrides.
- **It waits for the run to end.** It fails if the run fails or outlives the
  job's timeout, and prints the run's ID and status.

A spoke calls it from a `workflow_dispatch` workflow, so an ad-hoc run is a
form in the Actions tab.

### 6. The run key, `job-runner`

A workload with any `scaleway.job` implies three leaves:

- an application, `scaleway/iam-application/job-runner`;
- a policy, granting `ServerlessJobsFullAccess` on the workload's project
  only;
- an API key on that application.

They sign in with the spoke's key, as every IAM kind does (LIB-0043 §1).
`job-runner` becomes a reserved name for an application, policy or key.

### 7. The image

`image` points at ghcr.io directly.

- **Scaleway pulls it without credentials,** so the package must be public.
- **A private image needs a registry Scaleway can authenticate to.** That is
  out of scope here.

## Consequences

- **A job is a few lines of `workload.yaml`,** planned and applied like any
  other entry.
- **A recurring job needs no machine** and no GitHub schedule.
- **An ad-hoc job is a form in the Actions tab,** and it leaves nothing
  behind.
- **Job secrets live in Secret Manager,** read only by their job.
- **A spoke can run any public image this way,** not just pigeon-cli's.
- **The job cluster stays for now,** beside the jobs.

## Out of scope

- **Retiring the Kapsule job cluster.** This is deferred until jobs have
  replaced its work, and gets an `out-of-scope` issue.
- **A private image registry, or a mirror of the ghcr.io image.** This is
  deferred.
- **Serverless Containers, for anything served over HTTP.** This is a
  boundary: batch work is a job.

## Verification

1. **A recurring job runs on schedule.** Its run appears in Scaleway's job
   runs and exits 0.
2. **An ad-hoc run works end to end.** `scaleway-job-run.yml` starts it,
   waits, and reports its status.
3. **No secret shows in plain env.** The definition's env holds no secret
   values, and its secrets reach the run.

## Amendments

### 2026-11-01: the deployer needs Serverless Jobs, and the run hides its IDs

1. **The workload deployer is granted `ServerlessJobsFullAccess`** when the
   workload declares any `scaleway.job`. It is also granted
   `SecretManagerFullAccess` when a job's env holds a `secretRef` or an
   `apiKey`, because the module keeps those values in Secret Manager.
   - The job definitions sign in with the deployer's key (§1:
     credentials workload), but v11.1.0 granted the deployer sets only for
     LIB-0043's compute kinds.
   - The first apply of a job failed with `insufficient permissions`, and
     data-ops stated its deployer's sets by hand until the template granted
     them.
2. **`scaleway-job-run.yml` masks the definition's and the run's IDs** and
   prints neither (LIB-0054 §4). Scaleway's console lists a job's runs.
3. **An entry may set `retries`** (whole number, default `0`). It becomes
   the definition's `retry_policy.max_retries`. Scaleway gives every
   definition a retry policy of 0, so v0.1.0, which left the block out, planned
   to remove it on every run.
