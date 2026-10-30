+++
title = "scaleway/compute-cluster"
description = "Scales a fleet of `pigeon-cli` job instances to the number of pending jobs (ADR-0138). Composes one `scaleway/compute-instance` (with `self_delete_on_exit = true`) plus one dedicated `scaleway/iam-application`/`iam-policy`/`iam-api-key` per entry in `var.jobs` -- each job gets its own IAM scope and its own keyring, isolated from every other job in the same cluster (ADR-0144). A job's own API key is the default credential for any `kind = \"bucket\"` keyring entry that doesn't specify its own, and `job_commands` strings may reference a keyring entry by alias (e.g. `\"${keyring.fastmail.alias}:\"`). An instance tears itself down the moment its job finishes, success or failure; remove its entry from `var.jobs` and re-apply to reconcile Terraform state once that's happened. By default every job instance also shares one cluster-wide Private Network and Public Gateway (ADR-0145) -- job buckets can be reached over Scaleway's private Object Storage endpoint instead of the public one, and no job gets a public IP (ADR-0146) -- but a job can opt out of this entirely with `enable_private_network = false`, becoming a plain, directly-reachable `compute-instance` with no dependency on the cluster's shared networking, or keep its Private Network attachment while also requesting its own public IP with `enable_ipv4 = true` (ADR-0149). The cluster's shared Private Network and Public Gateway can also each be disabled independently of the other, via `cluster_config.enable_private_network`/`enable_public_gateway` (ADR-0149) -- e.g. tear down the Private Network once no job needs it anymore while leaving the Gateway (and its stable IP) running. For debug SSH access, set `cluster_config.enable_bastion = true` to provision a dedicated bastion instance on that same Private Network, reachable via the Public Gateway's PAT rule -- see the `bastion_connect_command` output; a direct public IP on an instance attached to this Private Network doesn't actually work while the Gateway is still pushing its default route (the gateway's own route advertisement takes priority), which is why the bastion doesn't get one either, and `enable_bastion` requires both `enable_private_network` and `enable_public_gateway` to stay `true`. `jobs` is a list, each entry naming its own `job_name` -- internally converted to a job-name-keyed map for stable per-job resource addressing."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "compute-cluster"
latest_version = "5.0.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/lib/terraform/scaleway/compute-cluster"
usage_example = """
module "pigeon_jobs" {
  source = "https://noisypigeon.garden/terraform/scaleway/compute-cluster/v5.0.0"

  cluster_config = {
    name_prefix = "pigeon-cli"
    project_id  = local.scaleway_project_id
    cockpit = {
      metrics_push_url = local.pigeon_cockpit_metrics_push_url
      logs_push_url    = local.pigeon_cockpit_logs_push_url
      token_secret     = local.pigeon_cockpit_token_secret
    }
    # Every job below gets this bucket for free, with no per-job declaration.
    shared_keyring = {
      reports = {
        kind     = "bucket"
        endpoint = "https://s3.fr-par.scw.cloud"
        bucket   = "pigeon-cli-vmqjtz-reports"
        # access_key_id/secret_key omitted -- each job defaults to its own API key
      }
    }
    shared_permission_sets = ["ObjectStorageFullAccess"]
  }

  jobs = [
    {
      job_name = "deduplicate-backblaze-snapshots"
      job_commands = [
        "cd pigeon-cli",
        "mise run pigeon-release job run deduplicate --source-bucket '${keyring.source.alias}:' --report-bucket '${keyring.reports.alias}:' --concurrency 8 --yes",
      ]
      keyring = {
        source = {
          kind     = "bucket"
          endpoint = "https://s3.fr-par.scw.cloud"
          bucket   = "backblaze-computer-snapshots"
          # this job reaches "source" under a pre-existing, shared auth stack
          # instead of defaulting to its own freshly-minted job key
          access_key_id = local.source_bucket_access_key_id
          secret_key    = local.source_bucket_secret_key
        }
      }
    },
    {
      job_name = "import-mega-consolidation"
      job_commands = [
        "cd pigeon-cli",
        "mise run pigeon-release job run rclone-import --remote '${keyring.mega.alias}:' --report-bucket '${keyring.reports.alias}:' --concurrency 4 --yes",
      ]
      keyring = {
        mega = {
          kind     = "bucket"
          endpoint = "https://s3.fr-par.scw.cloud"
          bucket   = "deduplicate-p7d0kd-backblaze-mega-consolidation"
          # access_key_id/secret_key omitted -- defaults to this job's own API key
        }
      }
    },
  ]
}
"""
versions = [{ version = "5.0.0", path = "terraform/scaleway/compute-cluster/v5.0.0" }]
+++
