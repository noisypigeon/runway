+++
title = "scaleway/compute-instance v8.0.0"
date = 2026-10-28T12:00:00-07:00
slug = "scaleway-compute-instance-v8.0.0"
description = "Give compute-instance a project, its own public IPv4 and a Private Network NIC"
+++

`compute-instance` v8.0.0 lets a workload's `scaleway.instance` leaf ([LIB-0043](https://github.com/noisypigeon/library/blob/main/docs/adr/LIB-0043-workload-compute-kinds.md) §7) stand on its own. It places the server in a project, creates the server's public IPv4 when asked, and attaches it to a Private Network, so no caller-side resources are needed.

### What's new

- **`project_id` is required.** The server, and any IP the module creates, live in it. Before this, the instance landed in the provider's default project, which for a workload leaf isn't the workload's. **This is the breaking change:** every caller has to pass `project_id` when it moves to v8.
- **`public_ipv4`** (default `false`) creates a `routed_ipv4` `scaleway_instance_ip` in `project_id` and attaches it alongside any `ip_ids`. It reverses DEV's ADR-0153 for the IP. One module can create an IP and the server that references it, and the IP goes with the server, as self-delete already has it. The IP isn't gated by `enabled`, so an `enabled = false` cycle keeps its address. While a Public Gateway pushes its default route on the instance's network, the IP works outbound only (ADR-0146).
- **`enable_private_network` and `private_network_id`** (default `false` and `null`) attach the server through a standalone `scaleway_instance_private_nic`, so attaching or detaching never replaces the server (ADR-0145). The toggle is an explicit bool for v5.6.0's reason: `count` can't depend on an apply-time-unknown ID. Setting `enable_private_network` without an ID fails validation. In a workload, the NIC has to land in the same apply as the server, or a gateway-only instance's cloud-init would run with no route out.
- **`private_ipv4`** outputs the server's IPv4 on its Private Network, with the dual-stack IPv6 address filtered out, for a PAT rule to target.

### Fixed

`cloud_init = null`, the default, no longer fails the plan. The module hashed `coalesce(var.cloud_init, "")`, and `coalesce` refuses when every argument is null or empty. The hash is unchanged for every value, so no server is replaced by the fix.

### Upgrading

Add `project_id`. A caller that creates its own `scaleway_instance_ip` and NIC, as `compute-cluster` does, can keep doing so through `ip_ids`, and leave the new inputs at their defaults. `compute-cluster` pins v7.0.0 and doesn't move.

Verified with `tofu validate`, `tofu fmt -check`, and `tofu test` with a mocked provider: one IP and one NIC with both on, none with both off, and `enable_private_network` without an ID refused. No plan was run against a live project.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

[#221](https://github.com/noisypigeon/library/pull/221)
