# Changelog

All notable changes to this module are documented in this file.

One line per release; its full notes are its GitHub Release (LIB-0049 §7).

## [8.0.0] - 2026-10-28

- Give compute-instance a project, its own public IPv4 and a Private Network NIC ([#221](https://github.com/noisypigeon/library/pull/221))

## [7.0.0] - 2026-10-10

- Split cloud-init into compute-instance-config; stop composing modules inside compute-instance ([#269](https://github.com/noisypigeon/noisypigeon/pull/269))

## [6.1.0] - 2026-10-10

- Install a pinned static ffmpeg for tiled HEIF transcoding ([#264](https://github.com/noisypigeon/noisypigeon/pull/264))

## [6.0.0] - 2026-10-10

- Rename compute-instance's enable_heic_transcoding to enable_transcoding ([#260](https://github.com/noisypigeon/noisypigeon/pull/260))

## [5.7.0] - 2026-10-10

- Add libheif-enabled ffmpeg support to compute-instance ([#257](https://github.com/noisypigeon/noisypigeon/pull/257))

## [5.6.1] - 2026-10-08

- Fix compute-instance's private_ips output to read from the private NIC ([#249](https://github.com/noisypigeon/noisypigeon/pull/249))

## [5.6.0] - 2026-10-08

- Fix compute-instance: private NIC count must not depend on private_network_id's nullness ([#246](https://github.com/noisypigeon/noisypigeon/pull/246))

## [5.5.0] - 2026-10-08

- Add Private Network support to compute-instance and pigeon-cluster ([#244](https://github.com/noisypigeon/noisypigeon/pull/244))

## [5.4.0] - 2026-10-07

- Add self-deletion to compute-instance and new pigeon-cluster module ([#237](https://github.com/noisypigeon/noisypigeon/pull/237))

## [5.3.1] - 2026-10-06

- Move module-redirect short URLs from noisypigeon.com to pigeon.dev ([#223](https://github.com/noisypigeon/noisypigeon/pull/223))

## [5.3.0] - 2026-10-04

- Add enabled kill switch to compute-instance ([#173](https://github.com/noisypigeon/noisypigeon/pull/173))

## [5.2.0] - 2026-10-04

- Add post_provision_commands to compute-instance ([#172](https://github.com/noisypigeon/noisypigeon/pull/172))

## [5.1.0] - 2026-10-04

- Compose iam-policy and iam-api-key inside compute-instance ([#167](https://github.com/noisypigeon/noisypigeon/pull/167))

## [5.0.1] - 2026-10-04

- Pin block-volume source in compute-instance ([#165](https://github.com/noisypigeon/noisypigeon/pull/165))

## [5.0.0] - 2026-10-04

- Rename block-volume's naming inputs and compose it inside compute-instance ([#163](https://github.com/noisypigeon/noisypigeon/pull/163))

## [4.0.0] - 2026-10-04

- Simplify scaleway/compute-instance's interface (ADR-0118) ([#157](https://github.com/noisypigeon/noisypigeon/pull/157))

## [3.0.0] - 2026-10-03

- Continue this module's version lineage under the templates/terraform prefix ([#144](https://github.com/noisypigeon/noisypigeon/pull/144))

## [2.3.4] - 2026-10-03

- Fix environment_variables/PIGEON_LOG_DIR not reaching non-login SSH invocations ([#133](https://github.com/noisypigeon/noisypigeon/pull/133))

## [2.3.3] - 2026-10-03

- Add a shared Cockpit metrics/logs store for pigeon-cli instances ([#132](https://github.com/noisypigeon/noisypigeon/pull/132))

## [2.3.2] - 2026-10-03

- Fix doubled Cockpit push path and non-resilient log tailing in compute-instance ([#131](https://github.com/noisypigeon/noisypigeon/pull/131))

## [2.3.1] - 2026-10-03

- Fix alloy install failing on a dpkg conffile prompt in compute-instance ([#130](https://github.com/noisypigeon/noisypigeon/pull/130))

## [2.3.0] - 2026-10-03

- Add Scaleway Cockpit wiring to compute-instance via Grafana Alloy ([#128](https://github.com/noisypigeon/noisypigeon/pull/128))

## [2.2.0] - 2026-10-02

- Make keyring bucket encryption key optional; add environment_variables ([#127](https://github.com/noisypigeon/noisypigeon/pull/127))

## [2.1.0] - 2026-10-02

- Add keyring_entries input for pigeon-cli keyring.toml ([#126](https://github.com/noisypigeon/noisypigeon/pull/126))

## [2.0.0] - 2026-10-02

- Merge rclone cloud-init profile into pigeon-cli ([#125](https://github.com/noisypigeon/noisypigeon/pull/125))

## [1.0.0] - 2026-10-02

- Move scaleway modules to top-level modules/, major release each ([#120](https://github.com/noisypigeon/noisypigeon/pull/120))

## [0.9.1] - 2026-10-02

- Fix missing $HOME in scaleway/compute-instance cloud-init runcmd ([#117](https://github.com/noisypigeon/noisypigeon/pull/117))

## [0.9.0] - 2026-10-02

- Auto-mount attached volume and inline pigeon-cli bootstrap on scaleway/compute-instance ([#116](https://github.com/noisypigeon/noisypigeon/pull/116))

## [0.8.0] - 2026-10-02

- Add pigeon-cli cloud-init profile and ipv4_address output to scaleway/compute-instance ([#115](https://github.com/noisypigeon/noisypigeon/pull/115))

## [0.7.0] - 2026-10-02

- Add cloud-init profiles (rclone/docker) to scaleway/compute-instance ([#114](https://github.com/noisypigeon/noisypigeon/pull/114))

## [0.6.0] - 2026-10-01

- Pre-install mise and a build toolchain in compute-instance's cloud-init ([#112](https://github.com/noisypigeon/noisypigeon/pull/112))

## [0.5.0] - 2026-10-01

- Attach a routed IPv4 address to compute-instance by default ([#111](https://github.com/noisypigeon/noisypigeon/pull/111))

## [0.4.0] - 2026-10-01

- Add scaleway/block-volume module and compute-instance volume attachment ([#109](https://github.com/noisypigeon/noisypigeon/pull/109))

## [0.3.1] - 2026-09-30

- Force instance replacement when compute-instance cloud-init changes ([#108](https://github.com/noisypigeon/noisypigeon/pull/108))

## [0.3.0] - 2026-09-30

- Add routed IPv6 and instance-specific SSH keys to scaleway/compute-instance ([#105](https://github.com/noisypigeon/noisypigeon/pull/105))

## [0.2.0] - 2026-09-30

- Add rclone/neovim cloud-init and bucket access to scaleway/compute-instance ([#104](https://github.com/noisypigeon/noisypigeon/pull/104))

## [0.1.0] - 2026-09-29

- docs(adr-0079): add scaleway/compute-instance module ([#86](https://github.com/noisypigeon/noisypigeon/pull/86))
