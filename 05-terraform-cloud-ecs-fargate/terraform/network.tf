data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "ECS VPC - ${local.app_name}"
    Env  = var.env
  }
}

resource "aws_subnet" "private" {
  count             = var.az_count
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Terraform ECS private subnet"
  }
}

resource "aws_subnet" "public" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Terraform ECS public subnet"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "Terraform ECS internet gateway"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_eip" "this" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count         = var.az_count
  subnet_id     = aws_subnet.public.*.id[count.index]
  allocation_id = aws_eip.this.*.id[count.index]

  tags = {
    Name = "Terraform ECS NAT gateway"
  }
}

resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.*.id[count.index]
  }

  tags = {
    Name = "Terraform ECS private route table"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.*.id[count.index]
}