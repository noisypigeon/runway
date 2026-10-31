+++
title = "scaleway/private-network"
description = "A thin wrapper around a single `scaleway_vpc_private_network`. It's a workload's `scaleway.privateNetwork` kind (LIB-0043): the network a workload's instances attach to, and its Public Gateway routes out of. Enabling Object Storage's private endpoint (`s3-vpc.<region>.scw.eu`) for the network is still a one-time manual step against the VPC API (ADR-0145)."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "private-network"
latest_version = "0.1.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/tools/terraform/scaleway/private-network"
usage_example = """
module "private_network" {
  source = "https://noisypigeon.garden/terraform/scaleway/private-network/v0.1.0"

  name       = "pigeon-cli"
  project_id = local.project_id
}
"""
versions = [{ version = "0.1.0", path = "terraform/scaleway/private-network/v0.1.0" }]
+++
