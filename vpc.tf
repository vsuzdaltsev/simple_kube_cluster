resource "aws_vpc" "kube" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(map("Name", "test-yaa-vpc"), var.default_tags)
}

resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.kube.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "eu-central-1a"

  tags = merge(map("Name", "DMZ subnet"), var.default_tags)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.kube.id

  tags = merge(map("Name", "Yaa test InternetGW"), var.default_tags)
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.kube.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(map("Name", "DMZ RT"), var.default_tags)
}

resource "aws_route_table_association" "public-rt" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_security_group" "sgweb" {
  name        = "vpc_test_web"
  description = "Allow traffic"

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.kube.id
  tags   = merge(map("Name", "public access"), var.default_tags)
}