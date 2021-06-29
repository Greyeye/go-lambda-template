data "aws_iam_policy_document" "apigateway_resource_policy" {

  statement {
    sid = "filtervpc"
    actions = [
      "execute-api:Invoke"
    ]
    resources = [
      "execute-api:/${var.environment}/*/*:*"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "aws:sourceVpc"

      values = [
        var.vpc_id
      ]
    }
    principals {
      type = "*"
      identifiers = ["*"]
    }
  }
}
