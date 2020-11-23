# Policies
data "aws_iam_policy_document" "ecs" {
  version = "2012-10-17"

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Roles
resource "aws_iam_role" "ecs" {
  name               = var.ecs_role
  assume_role_policy = data.aws_iam_policy_document.ecs.json
}

resource "aws_iam_role_policy_attachment" "ecs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs.name
}

resource "aws_iam_role" "ecs_auto_scale" {
  name               = var.ecs_auto_scale_role
  assume_role_policy = data.aws_iam_policy_document.ecs.json
}

resource "aws_iam_role_policy_attachment" "ecs_auto_scale" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
  role       = aws_iam_role.ecs_auto_scale.name
}