# Changelog

All notable changes to this module are documented in this file.

One line per release; its full notes are its GitHub Release (LIB-0049 §7).

## [4.0.0] - 2026-10-19

- Take pigeon-cli's keyring shape and repin compute-instance-config to v1.0.0 ([#79](https://github.com/noisypigeon/library/pull/79))

## [3.0.1] - 2026-10-16

- Use noisypigeon.garden/terraform/ short URLs ([#53](https://github.com/noisypigeon/pigeon-lib/pull/53))

## [3.0.0] - 2026-10-10

- Compose cloud-init, volumes, IPs, NICs and self-delete IAM at the cluster level ([#270](https://github.com/noisypigeon/noisypigeon/pull/270))

## [2.0.1] - 2026-10-10

- Re-pin compute-instance to v6.1.0 ([#265](https://github.com/noisypigeon/noisypigeon/pull/265))

## [2.0.0] - 2026-10-10

- Rename pigeon-cluster's jobs[*].enable_heic_transcoding to enable_transcoding, re-pin compute-instance v6.0.0 ([#261](https://github.com/noisypigeon/noisypigeon/pull/261))

## [1.3.0] - 2026-10-10

- Re-pin pigeon-cluster to compute-instance v5.7.0, add per-job HEIC transcoding opt-in ([#258](https://github.com/noisypigeon/noisypigeon/pull/258))

## [1.2.0] - 2026-10-09

- Add per-job network opt-out and independent Private Network/Public Gateway toggles to pigeon-cluster ([#254](https://github.com/noisypigeon/noisypigeon/pull/254))

## [1.1.0] - 2026-10-08

- Expose pigeon-cluster's Public Gateway offer type as a variable ([#251](https://github.com/noisypigeon/noisypigeon/pull/251))

## [1.0.0] - 2026-10-08

- Fold debug-SSH bastion into pigeon-cluster, drop per-job enable_ipv4 ([#250](https://github.com/noisypigeon/noisypigeon/pull/250))

## [0.3.2] - 2026-10-08

- Wire pigeon-cluster to compute-instance's new enable_private_network flag ([#247](https://github.com/noisypigeon/noisypigeon/pull/247))

## [0.3.1] - 2026-10-08

- Fix pigeon-cluster's stale internal compute-instance pin ([#245](https://github.com/noisypigeon/noisypigeon/pull/245))

## [0.3.0] - 2026-10-08

- Add Private Network support to compute-instance and pigeon-cluster ([#244](https://github.com/noisypigeon/noisypigeon/pull/244))

## [0.2.1] - 2026-10-07

- Fix pigeon-cluster job_policy name colliding with compute-instance's internal policy ([#242](https://github.com/noisypigeon/noisypigeon/pull/242))

## [0.2.0] - 2026-10-07

- Give pigeon-cluster jobs their own IAM policy/key and a dictionary keyring ([#241](https://github.com/noisypigeon/noisypigeon/pull/241))

## [0.1.0] - 2026-10-07

- Add self-deletion to compute-instance and new pigeon-cluster module ([#237](https://github.com/noisypigeon/noisypigeon/pull/237))
