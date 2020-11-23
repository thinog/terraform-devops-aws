resource "aws_security_group" "lb" {
  name        = "${local.app_name}-load-balancer-security-group"
  description = "Controls access to the ALB"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Load Balancer SG"
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${local.app_name}-ecs-tasks-security-group"
  description = "Allow inbound access from the ALB only"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ECS Tasks SG"
  }
}
