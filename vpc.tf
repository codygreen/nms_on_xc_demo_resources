resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name  = format("%s-nms-vpc", local.owner_name_safe)
    Owner = var.owner_email
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "private" {
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = format("%s-nms-private", local.owner_name_safe)
  }
}

resource "aws_subnet" "public" {
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = format("%s-nms-public", local.owner_name_safe)
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name  = "default"
    Owner = var.owner_email
  }
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public.id
  tags = {
    "Name" = format("%s-nms-ngw", local.owner_name_safe)
    Owner  = var.owner_email
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "ngw" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "igw" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.igw.id
}

resource "aws_route_table_association" "ngw" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.ngw.id
}

resource "aws_security_group" "egress" {
  name        = format("%s-ubuntu-egress", local.owner_name_safe)
  description = "egress"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  tags = {
    Name  = format("%s-ubuntu-egress", local.owner_name_safe)
    Owner = var.owner_email
  }
}
