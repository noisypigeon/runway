+++
title = "scaleway/public-gateway"
description = "A Scaleway Public Gateway attached to one Private Network: its public IP (`scaleway_vpc_public_gateway_ip`), the gateway (`scaleway_vpc_public_gateway`) and the attachment (`scaleway_vpc_gateway_network`), with masquerade and the default route on by default. It's a workload's `scaleway.publicGateway` kind (LIB-0043), and is the shared gateway `compute-cluster` creates for its jobs. While the gateway pushes its default route, an instance on the network that also has its own public IP can use it outbound only (ADR-0146). Its `type` can be upgraded in place but never downgraded."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "public-gateway"
latest_version = "0.1.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/lib/terraform/scaleway/public-gateway"
usage_example = """
module "public_gateway" {
  source = "https://noisypigeon.garden/terraform/scaleway/public-gateway/v0.1.0"

  name               = "pigeon-cli"
  project_id         = local.project_id
  private_network_id = module.private_network.id
}
"""
versions = [{ version = "0.1.0", path = "terraform/scaleway/public-gateway/v0.1.0" }]
+++
