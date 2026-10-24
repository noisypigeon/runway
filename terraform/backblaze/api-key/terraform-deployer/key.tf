# The spoke's Backblaze deployer key (LIB-0033 §2), minted by the bootstrap key
# in backblaze_breakglass.enc, which can only mint. Account-wide, since B2 needs
# an unrestricted key to create or reconfigure a bucket (LIB-0033 §5).
module "key" {
  source = "https://noisypigeon.garden/terraform/backblaze/api-key/v0.1.1"

  key_name = "runway-backblaze-deployer"
  capabilities = [
    "listBuckets", "readBuckets", "writeBuckets", "deleteBuckets",
    "readBucketEncryption", "writeBucketEncryption",
    "readBucketRetentions", "writeBucketRetentions",
    "readBucketLifecycleRules", "writeBucketLifecycleRules",
    "readBucketNotifications", "writeBucketNotifications",
    "readBucketReplications", "writeBucketReplications",
    "listKeys", "writeKeys", "deleteKeys",
    "listFiles", "readFiles", "shareFiles", "writeFiles", "deleteFiles",
    "readFileLegalHolds", "writeFileLegalHolds",
    "readFileRetentions", "writeFileRetentions",
  ]
  valid_duration_in_seconds = 31536000
}
