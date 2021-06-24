data "aws_iam_policy_document" "lambda_policy" {

  statement {
    sid = "loghander1"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${var.accountnumber}:log-group:/aws/lambda/${var.project_name}*"
    ]
  }


  statement {
    sid = "loghander2"
    actions = [
      "logs:CreateLogGroup",
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${var.accountnumber}:*"
    ]
  }
  statement {
    sid = "dynamodb1"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:Get*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:Delete*",
      "dynamodb:Update*",
      "dynamodb:PutItem"

    ]
    resources = [
      "arn:aws:dynamodb:${var.aws_region}:${var.accountnumber}:table*"
    ]
  }
  statement {
    sid ="vpceni1"
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses"
    ]
    resources = ["*"]
  }

}
