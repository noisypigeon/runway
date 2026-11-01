# Changelog

All notable changes to the reusable CI are documented in this file.

One line per release; its full notes are its GitHub Release (LIB-0049 §7).

## [10.1.3] - 2026-10-31

- fix(github/workflows): write site-r2's directory aliases with put-object ([#176](https://github.com/noisypigeon/runway/pull/176))

## [10.1.2] - 2026-10-31

- fix(github/terragrunt): name a site's bucket with dashes, and mint its token after it ([#172](https://github.com/noisypigeon/runway/pull/172))

## [10.1.1] - 2026-10-30

- fix(lib-0051): publish cloudflare/r2-custom-domain's inputs schema ([#167](https://github.com/noisypigeon/runway/pull/167))

## [10.1.0] - 2026-10-30

- feat(lib-0051): deployments.cloudflare, its zone rulesets, and site-r2.yml ([#166](https://github.com/noisypigeon/runway/pull/166))

## [10.0.0] - 2026-10-30

- feat(lib-0050)!: the CI unit under tools/github/, fetched into .pigeon/ ([#161](https://github.com/noisypigeon/runway/pull/161))

## [9.4.3] - 2026-10-30

- feat(lib-0049): one-line unit changelogs, release posts from Releases ([#156](https://github.com/noisypigeon/runway/pull/156))

## [9.4.2] - 2026-10-30

- feat(lib-0049): release-pr as the library plugin, marketplace under lib/ ([#152](https://github.com/noisypigeon/runway/pull/152))

## [9.4.1] - 2026-10-30

- feat(lib-0049): garden pages for each workflows version ([#151](https://github.com/noisypigeon/runway/pull/151))

## [9.4.0] - 2026-10-30

- ci(lib-0049): move the reusable workflows to lib/github-workflows ([#150](https://github.com/noisypigeon/runway/pull/150))

## [9.3.0] - 2026-10-29

- Address the library at its new home in runway (LIB-0047) ([#102](https://github.com/noisypigeon/runway/pull/102))

## [9.2.0] - 2026-10-28

- Owner-granted cross-workload Backblaze keys, and workload schema v6 (LIB-0045) ([#234](https://github.com/noisypigeon/library/pull/234))

## [9.1.0] - 2026-10-28

- Add check-policies.sh and the backblaze-bucket-owners policy (LIB-0045) ([#233](https://github.com/noisypigeon/library/pull/233))

## [9.0.2] - 2026-10-28

- Leave earlier stages' destroys out of a staged replan or apply comment ([#229](https://github.com/noisypigeon/library/pull/229))

## [9.0.1] - 2026-10-28

- Honour apexRedirect include_www: false in the resolver's clash check ([#228](https://github.com/noisypigeon/library/pull/228))

## [9.0.0] - 2026-10-28

- Scaleway compute kinds in resolve-workloads.sh, and workload schema v5 ([#225](https://github.com/noisypigeon/library/pull/225))

## [8.2.0] - 2026-10-28

- Plan workload leaves in waves, and replan only the stage left ([#216](https://github.com/noisypigeon/library/pull/216))

## [8.1.0] - 2026-10-28

- A workload's own Backblaze key, and providers with no spoke-wide credentials ([#208](https://github.com/noisypigeon/library/pull/208))

## [8.0.1] - 2026-10-27

- A workload in its own project doesn't repeat its name in its resources ([#206](https://github.com/noisypigeon/library/pull/206))

## [8.0.0] - 2026-10-26

- Refuse unwrapped unit files (LIB-0039) ([#203](https://github.com/noisypigeon/library/pull/203))

## [7.1.0] - 2026-10-26

- Wrapped unit files, dnsRecords and zone services (LIB-0039) ([#202](https://github.com/noisypigeon/library/pull/202))

## [7.0.0] - 2026-10-26

- Compose deployers and redirects from single-resource modules (LIB-0038) ([#195](https://github.com/noisypigeon/library/pull/195))

## [6.1.0] - 2026-10-25

- Read workloads that live in their zone (LIB-0037) ([#189](https://github.com/noisypigeon/library/pull/189))

## [6.0.0] - 2026-10-25

- Refuse zones.yaml, workload rulesets and redirects, and hand-written zone leaves ([#181](https://github.com/noisypigeon/library/pull/181))

## [5.4.0] - 2026-10-24

- Announce a staged apply's next-stage plan as it starts ([#180](https://github.com/noisypigeon/library/pull/180))

## [5.3.0] - 2026-10-24

- Acknowledge a terragrunt comment at once, outside the PR's queue ([#179](https://github.com/noisypigeon/library/pull/179))

## [5.2.2] - 2026-10-24

- Auto-merge only after an apply that ran and succeeded ([#178](https://github.com/noisypigeon/library/pull/178))

## [5.2.1] - 2026-10-24

- Fix resolve-workloads.sh --list failing in a spoke without zones ([#177](https://github.com/noisypigeon/library/pull/177))

## [5.2.0] - 2026-10-24

- Add zone units, zones/<zone>/zone.yaml (LIB-0036) ([#176](https://github.com/noisypigeon/library/pull/176))

## [5.1.1] - 2026-10-24

- A release regenerates noisypigeon.garden in runway (LIB-0035) ([#173](https://github.com/noisypigeon/library/pull/173))

## [5.1.0] - 2026-10-24

- Reusable site-generate.yml and site-pages.yml (LIB-0035) ([#172](https://github.com/noisypigeon/library/pull/172))

## [5.0.1] - 2026-10-24

- A theme release dispatches pages.yml in noisypigeon/noisypigeon.com (LIB-0034) ([#169](https://github.com/noisypigeon/library/pull/169))

## [5.0.0] - 2026-10-24

- Read each site's Pages shim from values.yaml and write the blog changelog one line per PR ([#167](https://github.com/noisypigeon/library/pull/167))

## [4.14.0] - 2026-10-24

- A site workload's features.githubPages implies its Pages CNAMEs (LIB-0034) ([#168](https://github.com/noisypigeon/library/pull/168))

## [4.13.1] - 2026-10-23

- resolve-workloads.sh --check accepts a Cloudflare stub's workload token ([#162](https://github.com/noisypigeon/library/pull/162))

## [4.13.0] - 2026-10-23

- Workloads sign in to Cloudflare with their own token; bootstrap keys only mint (LIB-0033) ([#159](https://github.com/noisypigeon/library/pull/159))

## [4.12.0] - 2026-10-23

- Site workloads deploy through a Pages shim repo (LIB-0031) ([#153](https://github.com/noisypigeon/library/pull/153))

## [4.11.0] - 2026-10-23

- Workloads can own Cloudflare zones, records, rulesets and redirects (LIB-0030) ([#152](https://github.com/noisypigeon/library/pull/152))

## [4.10.1] - 2026-10-22

- Comment-triggered runs check out the PR's head commit from the API ([#146](https://github.com/noisypigeon/library/pull/146))

## [4.10.0] - 2026-10-22

- Workloads can declare Backblaze buckets and API keys (LIB-0029) ([#145](https://github.com/noisypigeon/library/pull/145))

## [4.9.1] - 2026-10-22

- A workload's state bucket uses the standard storage class (LIB-0028) ([#143](https://github.com/noisypigeon/library/pull/143))

## [4.9.0] - 2026-10-22

- Every workload gets its own project, deployer and state bucket (LIB-0028) ([#141](https://github.com/noisypigeon/library/pull/141))

## [4.8.0] - 2026-10-22

- Merge a settled automatic re-plan without a last apply (LIB-0027) ([#136](https://github.com/noisypigeon/library/pull/136))

## [4.7.1] - 2026-10-22

- Fix the apply's merge-gate step crashing on getOctokit ([#134](https://github.com/noisypigeon/library/pull/134))

## [4.7.0] - 2026-10-22

- Re-plan staged applies automatically, and merge with the bot token (LIB-0027) ([#133](https://github.com/noisypigeon/library/pull/133))

## [4.6.0] - 2026-10-22

- Count unchanged leaves instead of listing them in Terragrunt comments ([#129](https://github.com/noisypigeon/library/pull/129))

## [4.5.0] - 2026-10-22

- Segment Terragrunt plan and apply comments by leaf, never truncated (LIB-0026) ([#127](https://github.com/noisypigeon/library/pull/127))

## [4.4.0] - 2026-10-21

- Add a workload secrets.yaml in SOPS YAML (LIB-0025) ([#119](https://github.com/noisypigeon/library/pull/119))

## [4.3.0] - 2026-10-20

- Give each workload its own deployer, and stage its applies (LIB-0024) ([#114](https://github.com/noisypigeon/library/pull/114))

## [4.2.0] - 2026-10-20

- Generate workload stubs in CI and plan removals as destroys (LIB-0023) ([#107](https://github.com/noisypigeon/library/pull/107))

## [4.1.0] - 2026-10-20

- Generate workload stubs and publish module inputs schemas (LIB-0023) ([#103](https://github.com/noisypigeon/library/pull/103))

## [4.0.1] - 2026-10-20

- fix(workflows): write changelogs on the newest main, not the merge commit ([#93](https://github.com/noisypigeon/library/pull/93))

## [4.0.0] - 2026-10-20

- feat(workflows): apply only the saved plan, and re-plan on comment (LIB-0022) ([#92](https://github.com/noisypigeon/library/pull/92))

## [3.5.0] - 2026-10-20

- Continue a renamed module's version track from its predecessor's last tag ([#84](https://github.com/noisypigeon/library/pull/84))

## [3.4.0] - 2026-10-20

- Add a reusable container image release workflow ([#83](https://github.com/noisypigeon/library/pull/83))

## [3.3.0] - 2026-10-19

- Add pigeon-cli's observability stack and Claude Code plugin ([#82](https://github.com/noisypigeon/library/pull/82))

## [3.2.0] - 2026-10-19

- Add a reusable Rust crate release workflow ([#81](https://github.com/noisypigeon/library/pull/81))

## [3.1.1] - 2026-10-17

- Name the hub noisypigeon/library ([#70](https://github.com/noisypigeon/library/pull/70))

## [3.1.0] - 2026-10-17

- Add per-leaf breakglass credentials to root.hcl and check-secrets ([#67](https://github.com/noisypigeon/pigeon-lib/pull/67))

## [3.0.0] - 2026-10-17

- Split spoke secrets into one sops file per concern ([#62](https://github.com/noisypigeon/pigeon-lib/pull/62))

## [2.0.0] - 2026-10-16

- Fixed secret names checked against a schema (root.hcl v3, workflows v2) ([#59](https://github.com/noisypigeon/pigeon-lib/pull/59))

## [1.6.2] - 2026-10-16

- Dispatch the blog deploy to noisypigeon/blog ([#56](https://github.com/noisypigeon/pigeon-lib/pull/56))

## [1.6.1] - 2026-10-16

- Drop pigeon.dev from comments and docs ([#55](https://github.com/noisypigeon/pigeon-lib/pull/55))

## [1.6.0] - 2026-10-16

- Publish module redirect pages under terraform/ instead of modules/ ([#52](https://github.com/noisypigeon/pigeon-lib/pull/52))

## [1.5.4] - 2026-10-16

- Dispatch the site deploy to noisypigeon/garden ([#51](https://github.com/noisypigeon/pigeon-lib/pull/51))

## [1.5.3] - 2026-10-16

- Fix state-backup.yml: compare state files by checksum ([#45](https://github.com/noisypigeon/pigeon-lib/pull/45))

## [1.5.2] - 2026-10-16

- Fix state-backup.yml: reach B2 through its S3-compatible API ([#44](https://github.com/noisypigeon/pigeon-lib/pull/44))

## [1.5.1] - 2026-10-15

- Stop terragrunt-run.yml running a leaf twice ([#41](https://github.com/noisypigeon/pigeon-lib/pull/41))

## [1.5.0] - 2026-10-15

- Add state-backup.yml: copy R2 Terraform state to a versioned B2 bucket (LIB-0007) ([#40](https://github.com/noisypigeon/pigeon-lib/pull/40))

## [1.4.1] - 2026-10-15

- Regenerate README tables for every module, not a hard-coded list ([#38](https://github.com/noisypigeon/pigeon-lib/pull/38))

## [1.4.0] - 2026-10-15

- Add a grafana-dashboards/<set>/vX.Y.Z release track ([#28](https://github.com/noisypigeon/pigeon-lib/pull/28))

## [1.3.2] - 2026-10-15

- Generate README tables for cloudflare/dns-record ([#25](https://github.com/noisypigeon/pigeon-lib/pull/25))

## [1.3.1] - 2026-10-15

- Add a --check mode to resolve-root-hcl.sh ([#17](https://github.com/noisypigeon/pigeon-lib/pull/17))

## [1.3.0] - 2026-10-15

- Let a spoke run terragrunt CI against a materialized root.hcl ([#15](https://github.com/noisypigeon/pigeon-lib/pull/15))

## [1.2.0] - 2026-10-15

- Add a reusable spoke-root-changelog.yml ([#14](https://github.com/noisypigeon/pigeon-lib/pull/14))

## [1.1.0] - 2026-10-15

- Let blog-changelog.yml take a site root via src_dir ([#13](https://github.com/noisypigeon/pigeon-lib/pull/13))

## [1.0.7] - 2026-10-15

- Read release notes from the default branch, not the pinned tree ([#12](https://github.com/noisypigeon/pigeon-lib/pull/12))

## [1.0.6] - 2026-10-15

- Stop the shared concurrency group dropping a release ([#10](https://github.com/noisypigeon/pigeon-lib/pull/10))

## [1.0.5] - 2026-10-15

- The Pages deploy timeout ceiling is hard, not a default ([#8](https://github.com/noisypigeon/pigeon-lib/pull/8))

## [1.0.4] - 2026-10-15

- Raise the Pages deploy timeout to 20 minutes ([#7](https://github.com/noisypigeon/pigeon-lib/pull/7))

## [1.0.3] - 2026-10-14

- Follow pigeon.dev's DEV- prefix rename ([#6](https://github.com/noisypigeon/pigeon-lib/pull/6))

## [1.0.2] - 2026-10-13

- Version the generator with the workflows track ([#5](https://github.com/noisypigeon/pigeon-lib/pull/5))

## [1.0.1] - 2026-10-13

- Stand down root-changelog for the workflows release track ([#3](https://github.com/noisypigeon/pigeon-lib/pull/3))

## [1.0.0] - 2026-10-13

- Seed the reusable CI's version track

<!-- continues-from: workflows/v9.4.3 -->
