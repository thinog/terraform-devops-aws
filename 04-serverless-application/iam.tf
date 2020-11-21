### Policies ###

# Cloudwatch policy
data "aws_iam_policy_document" "cloudwatch" {
  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}

resource "aws_iam_policy" "cloudwatch" {
  name   = "terraform-cloudwatch-policy"
  policy = data.aws_iam_policy_document.cloudwatch.json
}

# Lambda invoking policy
data "aws_iam_policy_document" "lambda" {
  # source_json = data.aws_iam_policy_document.cloudwatch.json

  statement {
    sid       = "AllowInvokingLambdas"
    effect    = "Allow"
    resources = ["arn:aws:lambda:*:*:function:*"]
    actions   = ["lambda:InvokeFunction"]
  }
}

resource "aws_iam_policy" "lambda" {
  name   = "terraform-lambda-policy"
  policy = data.aws_iam_policy_document.lambda.json
}

# DynamoDB policy
data "aws_iam_policy_document" "dynamodb" {
  statement {
    sid       = "AllowDynamoPermissions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["dynamodb:*"]
  }
}

resource "aws_iam_policy" "dynamodb" {
  name   = "terraform-dynamodb-policy"
  policy = data.aws_iam_policy_document.dynamodb.json
}

# S3 policy
data "aws_iam_policy_document" "s3" {
  statement {
    sid       = "AllowS3Permissions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["s3:*"]
  }
}

resource "aws_iam_policy" "s3" {
  name   = "terraform-s3-policy"
  policy = data.aws_iam_policy_document.s3.json
}

# SNS policy
data "aws_iam_policy_document" "sns" {
  statement {
    sid       = "AllowSNSPermissions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["sns:*"]
  }
}

resource "aws_iam_policy" "sns" {
  name   = "terraform-sns-policy"
  policy = data.aws_iam_policy_document.sns.json
}

### Roles ###

# DynamoDB Role
resource "aws_iam_role" "dynamodb" {
  name               = "terraform-dynamodb-lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "dynamodb" {
  policy_arn = aws_iam_policy.dynamodb.arn
  role       = aws_iam_role.dynamodb.name
}

resource "aws_iam_role_policy_attachment" "dynamodb_lambda" {
  policy_arn = aws_iam_policy.lambda.arn
  role       = aws_iam_role.dynamodb.name
}

resource "aws_iam_role_policy_attachment" "dynamodb_cloudwatch" {
  policy_arn = aws_iam_policy.cloudwatch.arn
  role       = aws_iam_role.dynamodb.name
}

# S3 Role
resource "aws_iam_role" "s3" {
  name               = "terraform-s3-lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3" {
  policy_arn = aws_iam_policy.s3.arn
  role       = aws_iam_role.s3.name
}

resource "aws_iam_role_policy_attachment" "s3_sns" {
  policy_arn = aws_iam_policy.sns.arn
  role       = aws_iam_role.s3.name
}

resource "aws_iam_role_policy_attachment" "s3_lambda" {
  policy_arn = aws_iam_policy.lambda.arn
  role       = aws_iam_role.s3.name
}

resource "aws_iam_role_policy_attachment" "s3_cloudwatch" {
  policy_arn = aws_iam_policy.cloudwatch.arn
  role       = aws_iam_role.s3.name
}
