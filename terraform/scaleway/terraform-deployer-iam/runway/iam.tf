# Signs in with this spoke's Scaleway key, which it doesn't manage. If it ever does, it needs a breakglass key.
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
