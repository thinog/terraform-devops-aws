resource "aws_security_group" "autoscaling" {
  name        = "autoscaling"
  description = "SG that allows ssh/http and all egress trafic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "Auto Scaling"
  }
}

resource "aws_launch_configuration" "lc" {
  name                        = "autoscaling-launcher"
  image_id                    = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_pair
  security_groups             = [aws_security_group.autoscaling.id]
  associate_public_ip_address = true
  user_data                   = file("scripts/ec2_setup.sh")
}

resource "aws_autoscaling_group" "asg" {
  name                      = "terraform-autoscaling"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.lc.name
  vpc_zone_identifier       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  target_group_arns         = [aws_lb_target_group.tg.arn]

  tag {
    key                 = "Name"
    value               = "terraform-autoscaling-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scaleup" {
  name                   = "Scale Up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "scaledown" {
  name                   = "Scale Down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "SimpleScaling"
}

resource "aws_instance" "jenkins" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.db.id]
  subnet_id              = aws_subnet.private_b.id
  availability_zone      = "${var.region}b"

  tags = {
    Name = "Jenkins instance"
  }
}