resource "aws_s3_bucket" "events_aws_bucket" {
  for_each = local.RepoTypes
  bucket   = "${each.key}-events-${var.env_name}"
  acl      = "private"

  tags = merge(var.tags, {
    Name           = "${each.key}-events-${var.env_name}"
    RepositoryType = each.key
  })

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  logging {
    target_bucket = aws_s3_bucket.access-log-aws-bucket.bucket
    target_prefix = "log/${each.key}-events-${var.env_name}/"
  }
}
