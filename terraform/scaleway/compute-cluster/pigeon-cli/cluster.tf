# Re-enabling this pins compute-cluster, which was pigeon-cluster until
# LIB-0020. Every pigeon-cluster tag before v3.0.1 nests module short URLs
# that no longer resolve (LIB-0009 §2). v3.0.0 moved cloud-init, volumes and
# IPs to the cluster level and v4.0.0 changed the keyring shape (LIB-0018), so
# read both modules' CHANGELOGs before uncommenting.
# module "cluster" {
#   source = "https://noisypigeon.garden/terraform/scaleway/compute-cluster/v5.0.0"

#   cluster_config = {
#     name_prefix         = "pigeon-cli"
#     enable_private_network = local.enable_private_network
#     enable_public_gateway = local.enable_public_gateway
#     project_id          = local.scaleway_project_id
#     enable_bastion      = local.enable_bastion
#     public_gateway_type = local.public_gateway_type
#     cockpit = {
#       metrics_push_url = local.cockpit_metrics_url
#       logs_push_url    = local.cockpit_logs_url
#       token_secret     = local.cockpit_token_secret
#     }
#     shared_keyring = {
#       reports = {
#         kind     = "bucket"
#         endpoint = "https://s3.fr-par.scw.cloud"
#         bucket   = "pigeon-cli-vmqjtz-reports"
#         provider = "Scaleway"
#       }
#     }
#     shared_permission_sets = ["ObjectStorageFullAccess"]
#   }

#   jobs = local.jobs
# }

# output "bastion_connect_command" {
#   description = "bastion_connect_command"
#   value       = module.cluster.bastion_connect_command
# }
