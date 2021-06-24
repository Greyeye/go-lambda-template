resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_name}-role-${var.environment}-${var.deploymentID}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json
  tags = var.tags
}

# create and attach inline policy
# if you want to attach fully managed policy, please use aws_iam_role_policy_attachment instead
resource "aws_iam_role_policy" "lambda_role_policy" {
  name = "${var.lambda_name}-policy-${var.environment}-${var.deploymentID}"
  role = aws_iam_role.lambda_role.id
  policy = var.policy == null ? data.aws_iam_policy_document.lambda_vpc_exec_policy.json : var.policy
}

# lambda scaffolding policy, enough to operate inside VPC and create CloudWatch logs
data "aws_iam_policy_document" "lambda_vpc_exec_policy" {

  statement {
    sid = "cloudwatch1"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${var.accountnumber}:log-group:/aws/lambda/${var.lambda_name}-${var.environment}-${var.deploymentID}:*"
    ]
  }
  statement {
    sid = "cloudwatch2"
    actions = [
      "logs:CreateLogGroup",
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${var.accountnumber}:*"
    ]
  }

  statement {
    sid = "vpceni1"
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

data "aws_iam_policy_document" "lambda_assume_policy" {
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}