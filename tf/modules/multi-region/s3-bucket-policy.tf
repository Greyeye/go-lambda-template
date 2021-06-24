# bucket policy to prevent access from non SSL/TLS connections
data "aws_iam_policy_document" "bucket-policy" {
  statement {
    sid = "1"
    effect = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${local.bucket_name}",
      "arn:aws:s3:::${local.bucket_name}/*"
    ]
    condition {
      test = "Bool"
      values = ["false"]
      variable = "aws:SecureTransport"
    }
    principals {
      type = "*"
      identifiers = ["*"]
    }
  }
}