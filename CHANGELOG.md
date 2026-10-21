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

## 2026-10-20

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
