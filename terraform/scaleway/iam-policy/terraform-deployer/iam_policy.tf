# Signs in with this spoke's Scaleway key, which it doesn't manage. If it ever does, it needs a breakglass key.
module "iam_policy" {
  source = "https://noisypigeon.garden/terraform/scaleway/iam-policy/v4.0.0"
  name   = "willowgraysen-com-terraform-deploy-policy"

  application_id = var.application_id

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
}
