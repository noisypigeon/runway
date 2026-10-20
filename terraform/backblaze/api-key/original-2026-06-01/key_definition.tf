locals {
  bucket_id = local.backblaze_original_bucket_id
  bucket_name = local.backblaze_original_bucket_name
  key_capabilities = [
    "listBuckets",
    "listFiles",
    "readFiles",
    "writeFiles",
    "deleteFiles",
    "listAllBucketNames",
    "readBuckets"
  ]
}
