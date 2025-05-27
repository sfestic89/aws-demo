resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  bucket_prefix = var.bucket_prefix

  dynamic "grant" {
    for_each = var.grants
    content {
      id          = lookup(grant.value, "id", null)
      permissions = grant.value.permissions
      type        = grant.value.type
      uri         = lookup(grant.value, "uri", null)
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status     = var.versioning_enabled ? "Enabled" : "Suspended"
    mfa_delete = var.mfa_delete
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
  count  = var.enable_encryption ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.encryption_algorithm
      kms_master_key_id = var.kms_key_id != "" ? var.kms_key_id : null
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_block_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "s3_bucket_logging" {
  count = var.logging_enabled ? 1 : 0

  bucket        = aws_s3_bucket.s3_bucket.id
  target_bucket = var.logging_target_bucket
  target_prefix = var.logging_target_prefix
}


resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status

      filter {
        prefix = lookup(rule.value, "prefix", "")
      }

      dynamic "transition" {
        for_each = lookup(rule.value, "transition", [])
        content {
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = lookup(rule.value, "expiration", []) != [] ? [1] : []
        content {
          days = lookup(rule.value.expiration[0], "days", null)
        }
      }
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "s3_bucket_replication" {
  count  = var.replication_enabled ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  role   = var.replication_role_arn

  dynamic "rule" {
    for_each = var.replication_rules
    content {
      id       = rule.value.id
      status   = rule.value.status
      priority = rule.value.priority

      filter {
        prefix = lookup(rule.value.filter, "prefix", "")
      }

      destination {
        bucket        = rule.value.destination.bucket
        storage_class = rule.value.destination.storage_class
      }
    }
  }
}
