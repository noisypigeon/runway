# Changelog

One line per PR across this whole repo, sectioned by date, newest first. Every
merged PR gets exactly one line here. DEV-0160 is the contract, adopted here by
RUN-0000.

Entry format is `- [<tag>] <PR title> ([#N](pr-url))`, where `<tag>` is one of:

- `terraform` — `terraform/`, `root.hcl`, `spoke.hcl`, `.sops.yaml`
- `adr` — decision records under `adr/`
- `ci` — `.github/` workflows
- `repo` — anything else (root docs, `.mise.toml`, `fetch-lib.sh`)

All of them are written by `root-changelog.yml`, which runs on every merged PR
with no exceptions. It calls `root-changelog.sh` out of the pinned library
rather than a vendored copy, and that script inserts below the marker at the end
of this header — keep that line where it is.

This file starts at this repo's own beginning. The Terraform leaves imported by
RUN-0001 keep their earlier history in git; changelog entries from before then
stayed in `noisypigeon/noisypigeon`.

<!-- entries below; newest first -->

## 2026-10-28

- [repo] feat(custodial-storage): move the custodial bucket into its own workload (LIB-0044) ([#94](https://github.com/noisypigeon/runway/pull/94))
- [repo] feat(custodial-storage): bootstrap the private/custodial-storage workload (LIB-0044) ([#93](https://github.com/noisypigeon/runway/pull/93))
- [terraform] chore: take library 8.2.0, faster Terragrunt plans (LIB-0042) ([#92](https://github.com/noisypigeon/runway/pull/92))
- [terraform] chore: retire the spoke-wide Backblaze key and Cloudflare token (LIB-0041) ([#91](https://github.com/noisypigeon/runway/pull/91))
- [terraform] chore: take library 8.1.0, cold-storage gets its own Backblaze key (LIB-0041) ([#90](https://github.com/noisypigeon/runway/pull/90))
- [terraform] feat: move the cold-storage buckets into their workload (LIB-0040) ([#89](https://github.com/noisypigeon/runway/pull/89))

## 2026-10-27

- [terraform] feat: add the cold-storage workload's own project (LIB-0040) ([#87](https://github.com/noisypigeon/runway/pull/87))
- [ci] chore: take workflows/v8.0.1 ([#88](https://github.com/noisypigeon/runway/pull/88))

## 2026-10-26

- [terraform] chore: take root-hcl 8.0.0 (LIB-0039) ([#86](https://github.com/noisypigeon/runway/pull/86))
- [ci] ci: take workflows/v8.0.0 (LIB-0039) ([#85](https://github.com/noisypigeon/runway/pull/85))
- [terraform] feat: wrap unit files and declare zone services (LIB-0039) ([#84](https://github.com/noisypigeon/runway/pull/84))
- [ci] ci: take workflows/v7.1.0 (LIB-0039) ([#83](https://github.com/noisypigeon/runway/pull/83))
- [terraform] feat(zones): compose deployers and redirects from single-resource modules (LIB-0038) ([#82](https://github.com/noisypigeon/runway/pull/82))
- [ci] ci: take workflows/v7.0.0 (LIB-0038) ([#81](https://github.com/noisypigeon/runway/pull/81))
- [repo] feat(workloads): remove blog's and garden's old workloads (LIB-0037) ([#80](https://github.com/noisypigeon/runway/pull/80))
- [ci] feat(workloads): move blog and garden into their zones (LIB-0037) ([#79](https://github.com/noisypigeon/runway/pull/79))

## 2026-10-25

- [terraform] feat(workloads): bootstrap blog and garden in their zones (LIB-0037) ([#76](https://github.com/noisypigeon/runway/pull/76))
- [ci] ci: take workflows/v6.1.0 (LIB-0037) ([#78](https://github.com/noisypigeon/runway/pull/78))
- [repo] feat(poc): remove the POC workload ([#75](https://github.com/noisypigeon/runway/pull/75))
- [repo] feat(poc): let the POC's state bucket force-destroy ([#77](https://github.com/noisypigeon/runway/pull/77))
- [repo] feat(poc): destroy the POC's buckets, IAM and API keys ([#74](https://github.com/noisypigeon/runway/pull/74))
- [terraform] chore: take workflows/v6.0.0 and root-hcl 6.0.0 (LIB-0036) ([#73](https://github.com/noisypigeon/runway/pull/73))

## 2026-10-24

- [repo] feat(zones): move the blog's mail, identity and redirect entries into their zones (LIB-0036) ([#72](https://github.com/noisypigeon/runway/pull/72))
- [ci] ci: acknowledge terragrunt comments at once, and announce a staged re-plan (LIB-0022, LIB-0027) ([#71](https://github.com/noisypigeon/runway/pull/71))
- [ci] feat(zones): bootstrap the four zone units (LIB-0036) ([#70](https://github.com/noisypigeon/runway/pull/70))
- [terraform] feat(zones): make each Cloudflare zone a unit of its own (LIB-0036) ([#69](https://github.com/noisypigeon/runway/pull/69))
- [ci] feat(garden): move the noisypigeon.garden site into workloads/garden (LIB-0035) ([#68](https://github.com/noisypigeon/runway/pull/68))
- [repo] Commit garden's imported Pages CNAMEs (LIB-0035) ([#67](https://github.com/noisypigeon/runway/pull/67))
- [repo] Bootstrap the garden workload, owning noisypigeon.garden (LIB-0035) ([#66](https://github.com/noisypigeon/runway/pull/66))
- [terraform] The blog declares its Pages shim in values.yaml (LIB-0034) ([#65](https://github.com/noisypigeon/runway/pull/65))
- [ci] Move the blog's site into workloads/blog ([#64](https://github.com/noisypigeon/runway/pull/64))
- [repo] Commit the blog's imported DNS records and redirects ([#63](https://github.com/noisypigeon/runway/pull/63))
- [ci] Take workflows v4.13.1 ([#62](https://github.com/noisypigeon/runway/pull/62))

## 2026-10-23

- [repo] Bootstrap the blog workload, owning its three zones ([#61](https://github.com/noisypigeon/runway/pull/61))
- [terraform] Sign in with the minted Cloudflare token and B2 key ([#60](https://github.com/noisypigeon/runway/pull/60))
- [terraform] Mint runway's Cloudflare token and B2 key from minting-only bootstrap keys ([#59](https://github.com/noisypigeon/runway/pull/59))
- [ci] Take workflows v4.12.0 ([#58](https://github.com/noisypigeon/runway/pull/58))

## 2026-10-22

- [ci] Take workflows v4.10.1 ([#57](https://github.com/noisypigeon/runway/pull/57))
- [terraform] Take LIB-0029: a Backblaze bucket and key in the POC ([#56](https://github.com/noisypigeon/runway/pull/56))
- [terraform] Take root.hcl v5.0.1 and workflows v4.9.1 ([#55](https://github.com/noisypigeon/runway/pull/55))
- [terraform] Take root.hcl v5.0.0 and recreate the POC in its own state bucket ([#54](https://github.com/noisypigeon/runway/pull/54))
- [ci] Take workflows v4.9.0 ([#53](https://github.com/noisypigeon/runway/pull/53))
- [repo] Destroy the POC's bucket and IAM leaves before LIB-0028 ([#52](https://github.com/noisypigeon/runway/pull/52))
- [repo] Restore the POC deployer's 30-day rotation ([#51](https://github.com/noisypigeon/runway/pull/51))
- [ci] Take workflows v4.8.0 ([#50](https://github.com/noisypigeon/runway/pull/50))
- [repo] Rotate the POC deployer's key ([#48](https://github.com/noisypigeon/runway/pull/48))
- [ci] Take workflows v4.7.1 ([#49](https://github.com/noisypigeon/runway/pull/49))
- [ci] Take workflows v4.7.0, with the replan job ([#47](https://github.com/noisypigeon/runway/pull/47))
- [ci] Take workflows v4.5.0 ([#45](https://github.com/noisypigeon/runway/pull/45))
- [repo] Rotate the POC secrets.yaml's data key ([#43](https://github.com/noisypigeon/runway/pull/43))

## 2026-10-21

- [terraform] Give the POC workload its first secrets.yaml (LIB-0025) ([#41](https://github.com/noisypigeon/runway/pull/41))
- [ci] Take workflows v4.4.0 alone ([#40](https://github.com/noisypigeon/runway/pull/40))

## 2026-10-20

- [terraform] Give the POC workload its own deployer (LIB-0024) ([#38](https://github.com/noisypigeon/runway/pull/38))
- [ci] Take workflows v4.3.0 alone ([#37](https://github.com/noisypigeon/runway/pull/37))
- [repo] Take workflows v4.2.0 and stop committing workload stubs ([#34](https://github.com/noisypigeon/runway/pull/34))
- [terraform] Add the LIB-0023 POC bucket and API key, from values.yaml alone ([#32](https://github.com/noisypigeon/runway/pull/32))
- [terraform] Add the LIB-0023 proof-of-concept workload (project and application) ([#31](https://github.com/noisypigeon/runway/pull/31))
- [terraform] Take LIB-0022: saved-plan applies and state locking ([#30](https://github.com/noisypigeon/runway/pull/30))
- [terraform] chore: clean-up ([#29](https://github.com/noisypigeon/runway/pull/29))
- [terraform] Move Scaleway bucket and cluster leaves to the renamed module paths ([#28](https://github.com/noisypigeon/runway/pull/28))
- [terraform] docs: trim runway's prose to LIB-0021 ([#27](https://github.com/noisypigeon/runway/pull/27))
- [terraform] Repin Scaleway buckets and the cluster leaf to the renamed library modules ([#26](https://github.com/noisypigeon/runway/pull/26))

## 2026-10-18

- [adr] docs: move decisions to library and remove adr/ (LIB-0017) ([#25](https://github.com/noisypigeon/runway/pull/25))

## 2026-10-17

- [terraform] State lives in the runway-prefixed bucket (LIB-0016) ([#24](https://github.com/noisypigeon/runway/pull/24))
- [terraform] State bucket takes the runway prefix (LIB-0016) ([#23](https://github.com/noisypigeon/runway/pull/23))
- [terraform] chore: remove pigeon-deduplicate bucket; rename project ([#22](https://github.com/noisypigeon/runway/pull/22))
- [terraform] chore: add new buckets and remove one old bucket ([#21](https://github.com/noisypigeon/runway/pull/21))
- [terraform] Fetch the pigeon-cli dashboard from noisypigeon/library ([#20](https://github.com/noisypigeon/runway/pull/20))
- [terraform] Call noisypigeon/library, the renamed hub ([#19](https://github.com/noisypigeon/runway/pull/19))
- [terraform] Hoist the deployer IAM into this repo behind a breakglass key ([#18](https://github.com/noisypigeon/runway/pull/18))
- [terraform] chore(terraform): split secrets per concern and take root.hcl v4 (LIB-0012) ([#17](https://github.com/noisypigeon/willowgraysen/pull/17))
- [terraform] chore(terraform): take root.hcl v3 with normalized secrets (LIB-0010) ([#16](https://github.com/noisypigeon/willowgraysen/pull/16))

## 2026-10-16

- [repo] docs: name the renamed noisypigeon/blog repo ([#15](https://github.com/noisypigeon/willowgraysen/pull/15))
- [terraform] docs: name noisypigeon/garden, not pigeon.dev, and take root.hcl v2.2.1 ([#14](https://github.com/noisypigeon/willowgraysen/pull/14))
- [terraform] chore(terraform): source modules from noisypigeon.garden (LIB-0009) ([#13](https://github.com/noisypigeon/willowgraysen/pull/13))
- [terraform] chore(terraform): hand the redirect to noisypigeon.com and turn Cloudflare off ([#12](https://github.com/noisypigeon/willowgraysen/pull/12))

## 2026-10-15

- [terraform] refactor(terraform): move the Grafana dashboard leaf onto grafana/dashboard ([#11](https://github.com/noisypigeon/willowgraysen.com/pull/11))
- [terraform] chore(terraform): take root.hcl v2.0.0, with providers named in spoke.hcl ([#10](https://github.com/noisypigeon/willowgraysen.com/pull/10))
- [repo] Describe the LIB-0004 layout in CLAUDE.md ([#9](https://github.com/noisypigeon/willowgraysen.com/pull/9))
- [terraform] Split the three multi-module leaves into one leaf per module ([#8](https://github.com/noisypigeon/willowgraysen.com/pull/8))
- [terraform] refactor(terraform): rename the single-module leaves to LIB-0004's layout ([#7](https://github.com/noisypigeon/willowgraysen.com/pull/7))
- [terraform] refactor(terraform): grafana leaf onto the template's latent provider and a pinned dashboard ([#6](https://github.com/noisypigeon/willowgraysen.com/pull/6))
- [terraform] refactor(terraform): move the redirect leaf onto the cloudflare wrapper modules ([#5](https://github.com/noisypigeon/willowgraysen.com/pull/5))
- [terraform] fix(terraform): stop the overview dashboard planning a change every run ([#4](https://github.com/noisypigeon/willowgraysen.com/pull/4))
- [terraform] fix(terraform): point the state bucket output at terraform/secrets.enc ([#3](https://github.com/noisypigeon/willowgraysen.com/pull/3))
- [terraform] feat(run-0001)!: run willowgraysen.com's Terraform from this repo ([#2](https://github.com/noisypigeon/willowgraysen.com/pull/2))
- [adr] chore(run-0000): bootstrap the repo as a pigeon-lib spoke and open the RUN- domain ([#1](https://github.com/noisypigeon/willowgraysen.com/pull/1))
