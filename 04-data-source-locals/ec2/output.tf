output "ec2_arn" {
  value = aws_instance.web.arn
}

output "ec2_ami" {
  value = data.aws_ami.ubuntu.id
}