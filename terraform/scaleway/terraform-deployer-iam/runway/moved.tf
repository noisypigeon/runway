# The state came from noisypigeon/noisypigeon's state/iam leaf, which called
# iam-application, iam-policy and iam-api-key separately (LIB-0014 §4).
moved {
  from = module.iam_application.scaleway_iam_application.application
  to   = module.terraform_deployer_iam.scaleway_iam_application.application
}

moved {
  from = module.iam_policy.scaleway_iam_policy.policy[0]
  to   = module.terraform_deployer_iam.scaleway_iam_policy.policy[0]
}

moved {
  from = module.iam_api_key.time_static.created
  to   = module.terraform_deployer_iam.time_static.created
}

moved {
  from = module.iam_api_key.scaleway_iam_api_key.api_key
  to   = module.terraform_deployer_iam.scaleway_iam_api_key.api_key
}
