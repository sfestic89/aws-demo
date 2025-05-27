module "s3_bucket" {
  source = "../../aws-modules/aws-storage/aws-s3-bucket"

   bucket_name          = "demo-dev-data-bucket"
   force_destroy        = false
   bucket_prefix        = null
   versioning_enabled   = true
   mfa_delete           = "Disabled"
   enable_encryption    = true
   encryption_algorithm = "aws:kms"
   kms_key_id           = "alias/my-kms-key" # Use a real key or set to null if default

   tags = {
     Environment = "dev"
     Owner       = "devops"
     Project     = "data-platform"
   }

   grants = [] # Optional: list of grant objects

   logging_enabled       = false
   #logging_target_bucket = "my-logging-bucket"
   #logging_target_prefix = "dev-logs/"

   lifecycle_rules = [
     {
       id     = "archive-old-objects"
       status = "Enabled"

       transition = [
         {
           days          = 30
           storage_class = "GLACIER"
         }
       ]

       expiration = [
         {
           days = 365
         }
       ]

       prefix = ""
     }
   ]

   replication_enabled  = false
   replication_role_arn = null
   replication_rules    = []
}