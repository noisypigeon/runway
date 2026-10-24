# CLAUDE.md

`noisypigeon/runway` is the Terraform for `willowgraysen.com`'s
infrastructure: pigeon-cli's object storage, job cluster, observability and
Grafana, the data-ops cold-storage buckets, and the IAM that ties them
together.

It also holds the blog, the one public thing here, as the `blog` workload
(LIB-0032):

- **`workloads/blog/`** is the noisypigeon.com Zola site (`config.toml`,
  `content/`, `static/`, `CHANGELOG.md`), beside its `values.yaml`.
- **`values.yaml`** owns the blog's zones in `zones.yaml`: the DNS records of
  noisypigeon.com and pigeon.dev, and the redirects from pigeon.dev and
  willowgraysen.com to noisypigeon.com. They were imported, not created, so
  change one only on purpose.
- **`noisypigeon/noisypigeon.com` is now only the Pages shim** (LIB-0031,
  LIB-0034), named by `values.yaml`'s `features.githubPages`. Merging a site
  change here dispatches its `pages.yml`, which builds this repo's `main`. A post
  is a PR like any other, but only `values.yaml` and `secrets.yaml` changes
  run a plan.

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
  library module.
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
