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

## 2026-10-31

- [terraform] chore: move runway's config into .config/ (LIB-0052) ([#189](https://github.com/noisypigeon/runway/pull/189))
- [github/workflows] fix(github/workflows): finish v11's .config/ support before runway moves ([#188](https://github.com/noisypigeon/runway/pull/188))
- [github/terragrunt] fix(github/workflows): finish v11's .config/ support before runway moves ([#188](https://github.com/noisypigeon/runway/pull/188))
- [github/workflows] feat(github/terragrunt)!: read a spoke's config from .config/ (LIB-0052) ([#186](https://github.com/noisypigeon/runway/pull/186))
- [github/terragrunt] feat(github/terragrunt)!: read a spoke's config from .config/ (LIB-0052) ([#186](https://github.com/noisypigeon/runway/pull/186))
- [adr] feat(lib-0051): retire the Pages path and garden's test host ([#185](https://github.com/noisypigeon/runway/pull/185))
- [ci] feat(lib-0051): serve noisypigeon.garden and www from R2 ([#184](https://github.com/noisypigeon/runway/pull/184))
- [repo] feat(lib-0051): garden's flip, first apply: drop githubPages ([#183](https://github.com/noisypigeon/runway/pull/183))
- [terraform] chore: take github/terragrunt and github/workflows v10.2.0 ([#182](https://github.com/noisypigeon/runway/pull/182))
- [github/workflows] feat(github/terragrunt): take workload modules from their git tags, not garden ([#181](https://github.com/noisypigeon/runway/pull/181))
- [github/terragrunt] feat(github/terragrunt): take workload modules from their git tags, not garden ([#181](https://github.com/noisypigeon/runway/pull/181))
- [ci] feat(lib-0051): serve noisypigeon.com and www from R2 ([#180](https://github.com/noisypigeon/runway/pull/180))
- [repo] feat(lib-0051): flip noisypigeon.com from Pages to R2 ([#179](https://github.com/noisypigeon/runway/pull/179))
- [ci] feat(lib-0051): the blog on R2 at a test host, beside Pages ([#178](https://github.com/noisypigeon/runway/pull/178))
- [ci] chore: take github/workflows v10.1.3, and redeploy garden on its own change ([#177](https://github.com/noisypigeon/runway/pull/177))
- [github/workflows] fix(github/workflows): write site-r2's directory aliases with put-object ([#176](https://github.com/noisypigeon/runway/pull/176))
- [terraform] feat(lib-0051): garden on R2 at a test host, beside Pages ([#175](https://github.com/noisypigeon/runway/pull/175))
- [github/terragrunt] fix(github/terragrunt): mark a Cloudflare bucket's output sensitive ([#174](https://github.com/noisypigeon/runway/pull/174))
- [github/workflows] fix(github/terragrunt): name a site's bucket with dashes, and mint its token after it ([#172](https://github.com/noisypigeon/runway/pull/172))
- [github/terragrunt] fix(github/terragrunt): name a site's bucket with dashes, and mint its token after it ([#172](https://github.com/noisypigeon/runway/pull/172))

## 2026-10-30

- [github/terragrunt] fix(lib-0051): the zone token's transform group is Zone Transform Rules Write ([#170](https://github.com/noisypigeon/runway/pull/170))
- [cloudflare/api-token] fix(lib-0051): name the nearest permission groups when api-token can't find one ([#169](https://github.com/noisypigeon/runway/pull/169))
- [ci] chore(lib-0051): take github/workflows/v10.1.1, and regenerate garden on a pin change ([#168](https://github.com/noisypigeon/runway/pull/168))
- [github/workflows] fix(lib-0051): publish cloudflare/r2-custom-domain's inputs schema ([#167](https://github.com/noisypigeon/runway/pull/167))
- [github/workflows] feat(lib-0051): deployments.cloudflare, its zone rulesets, and site-r2.yml ([#166](https://github.com/noisypigeon/runway/pull/166))
- [github/terragrunt] feat(lib-0051): deployments.cloudflare, its zone rulesets, and site-r2.yml ([#166](https://github.com/noisypigeon/runway/pull/166))
- [cloudflare/r2-custom-domain] feat(lib-0051): cloudflare/r2-custom-domain, and bucket-scoped api-token policies ([#165](https://github.com/noisypigeon/runway/pull/165))
- [cloudflare/api-token] feat(lib-0051): cloudflare/r2-custom-domain, and bucket-scoped api-token policies ([#165](https://github.com/noisypigeon/runway/pull/165))
- [adr] docs(adr): LIB-0051 sites on Cloudflare R2, LIB-0052 spoke config in .config/ ([#164](https://github.com/noisypigeon/runway/pull/164))
- [adr] chore(lib-0050): runway fetches through .pigeon/ at github/workflows/v10.0.0 ([#163](https://github.com/noisypigeon/runway/pull/163))
- [observability/lgtm-stack] feat(lib-0050): theme, plugins, stack and dashboards on their new tracks ([#162](https://github.com/noisypigeon/runway/pull/162))
- [claude/plugins/pigeon-cli] feat(lib-0050): theme, plugins, stack and dashboards on their new tracks ([#162](https://github.com/noisypigeon/runway/pull/162))
- [claude/plugins/library] feat(lib-0050): theme, plugins, stack and dashboards on their new tracks ([#162](https://github.com/noisypigeon/runway/pull/162))
- [static-site/zola] feat(lib-0050): theme, plugins, stack and dashboards on their new tracks ([#162](https://github.com/noisypigeon/runway/pull/162))
- [github/workflows] feat(lib-0050)!: the CI unit under tools/github/, fetched into .pigeon/ ([#161](https://github.com/noisypigeon/runway/pull/161))
- [github/terragrunt] feat(lib-0050)!: the CI unit under tools/github/, fetched into .pigeon/ ([#161](https://github.com/noisypigeon/runway/pull/161))
- [adr] chore(lib-0050): move lib/ to tools/ ([#160](https://github.com/noisypigeon/runway/pull/160))
- [adr] docs(adr): LIB-0050 lib/ becomes tools/ ([#159](https://github.com/noisypigeon/runway/pull/159))
- [lib] docs(lib-0049): backfill every unit changelog to one line per release ([#158](https://github.com/noisypigeon/runway/pull/158))
- [ci] chore(lib-0049): take workflows/v9.4.3 and library v1.0.1 ([#157](https://github.com/noisypigeon/runway/pull/157))
- [workflows] feat(lib-0049): one-line unit changelogs, release posts from Releases ([#156](https://github.com/noisypigeon/runway/pull/156))
- [claude-plugins/library] feat(lib-0049): one-line unit changelogs, release posts from Releases ([#156](https://github.com/noisypigeon/runway/pull/156))
- [lib] docs(lib-0049): one CLAUDE.md and one .gitignore ([#155](https://github.com/noisypigeon/runway/pull/155))
- [adr] docs(lib-0049): move adr/ and runbooks/ under lib/docs/ ([#154](https://github.com/noisypigeon/runway/pull/154))
- [lib] chore(lib-0049): take workflows/v9.4.2 and the library plugin ([#153](https://github.com/noisypigeon/runway/pull/153))
- [workflows] feat(lib-0049): release-pr as the library plugin, marketplace under lib/ ([#152](https://github.com/noisypigeon/runway/pull/152))
- [claude-plugins/library] feat(lib-0049): release-pr as the library plugin, marketplace under lib/ ([#152](https://github.com/noisypigeon/runway/pull/152))
- [workflows] feat(lib-0049): garden pages for each workflows version ([#151](https://github.com/noisypigeon/runway/pull/151))
- [workflows] ci(lib-0049): move the reusable workflows to lib/github-workflows ([#150](https://github.com/noisypigeon/runway/pull/150))
- [adr] docs(adr): LIB-0049 finish the hoist ([#149](https://github.com/noisypigeon/runway/pull/149))
- [adr] docs(adr): LIB-0048 pin runner labels past macos-14 ([#147](https://github.com/noisypigeon/runway/pull/147))
- [adr] docs(adr): LIB-0047 done amendment ([#148](https://github.com/noisypigeon/runway/pull/148))

## 2026-10-29

- [terraform] chore: take the library from runway's lib/ (LIB-0047) ([#104](https://github.com/noisypigeon/runway/pull/104))
- [claude-plugins/pigeon-cli] Point the template, theme and plugin at runway (LIB-0047) ([#103](https://github.com/noisypigeon/runway/pull/103))
- [terragrunt/root-hcl] Point the template, theme and plugin at runway (LIB-0047) ([#103](https://github.com/noisypigeon/runway/pull/103))
- [zola-site] Point the template, theme and plugin at runway (LIB-0047) ([#103](https://github.com/noisypigeon/runway/pull/103))
- [workflows] Address the library at its new home in runway (LIB-0047) ([#102](https://github.com/noisypigeon/runway/pull/102))
- [ci] feat: hoist the library into lib/ (LIB-0047) ([#101](https://github.com/noisypigeon/runway/pull/101))

## 2026-10-28

- [ci] ci: rename the blog-changelog and interaction-limits callers (LIB-0047) ([#100](https://github.com/noisypigeon/runway/pull/100))
- [terraform] feat(data-ops): move pigeon-cli's buckets into private/data-ops (LIB-0046) ([#99](https://github.com/noisypigeon/runway/pull/99))
- [terraform] feat(data-ops): bootstrap private/data-ops with runway's project (LIB-0046) ([#98](https://github.com/noisypigeon/runway/pull/98))
- [terraform] feat: enforce library policies; take workflows v9.2.0 and root.hcl 9.1.1 (LIB-0045) ([#97](https://github.com/noisypigeon/runway/pull/97))
- [repo] feat(custodial-cold-storage): rename the custodial-storage workload (LIB-0044) ([#96](https://github.com/noisypigeon/runway/pull/96))
- [repo] feat(personal-cold-storage): rename the cold-storage workload (LIB-0044) ([#95](https://github.com/noisypigeon/runway/pull/95))
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
