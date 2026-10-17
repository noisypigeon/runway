# This spoke's Terraform deployer identity (LIB-0014), hoisted from
# noisypigeon/noisypigeon's willowgraysen.com/terraform/state/iam. It manages
# the key every other leaf here deploys with, so it signs in with the
# breakglass key instead (spoke.hcl providers.scaleway.breakglass). The names
# are the ones the objects already have; renaming them is
# noisypigeon/noisypigeon#324.
module "terraform_deployer_iam" {
  source = "https://noisypigeon.garden/terraform/scaleway/terraform-deployer-iam/v0.1.0"

  name        = "willowgraysen-com-terraform-deploy"
  policy_name = "willowgraysen-com-terraform-deploy-policy-policy"

  project_ids = [local.scaleway_project_id]
  project_permission_sets = [
    "InstancesFullAccess",
    "ObjectStorageFullAccess",
    "VPCFullAccess",
    "BlockStorageFullAccess",
    "SSHKeysReadOnly",
    "SSHKeysFullAccess",
    "ObservabilityFullAccess",
    "PrivateNetworksFullAccess",
    "VPCGatewayFullAccess",
    "IPAMFullAccess"
  ]

  organization_id = local.scaleway_organization_id
  organization_permission_sets = [
    "ProjectManager",
    "IAMManager",
    "IAMApplicationManager"
  ]

  default_project_id = local.scaleway_project_id
}
