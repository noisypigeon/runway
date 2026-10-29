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
  `content/terraform/`, `content/theme-versions/` and `content/releases/`, and
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

It is a spoke of `noisypigeon/library`. Modules, CI logic, scripts and
decision records all live there. Don't add them here.

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
- This repo cuts no releases and has no `release:*` labels.
- Take a library change by bumping `.lib-version` and the `@workflows/vX.Y.Z`
  refs, or `root_hcl_version` in `spoke.hcl`. Never track a branch. For local
  iteration, point `LIB_SRC` at a library checkout.

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
