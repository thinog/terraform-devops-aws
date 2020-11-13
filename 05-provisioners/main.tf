provider "aws" {
  region = var.region
}

locals {
  file = file("~/Downloads/thinog.pem")
}

resource "aws_instance" "web" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = "thinog"

  provisioner "file" {
    source = "file.log"
    destination = "/tmp/tf-log.log"

    connection {
      type = "ssh"
      user = "ec2-user"
      timeout = "1m"
      private_key = local.file
      host = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 5",
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo service httpd start",
      "sudo chkconfig httpd on",
      "sleep 5"
    ]

    connection {
      type = "ssh"
      user = "ec2-user"
      timeout = "1m"
      private_key = local.file
      host = self.public_ip
    }
  }
}

resource "null_resource" "null" {
  depends_on = [
    aws_instance.web
  ]

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.private_ip} >> private_ip.txt; echo ${aws_instance.web.public_ip} >> public_ip.txt;"
  }
}