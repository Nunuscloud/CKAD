resource "aws_vpc" "cka_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "cka_vpc"
  }
}

# Subnets
resource "aws_subnet" "cka_subnet_1" {
  vpc_id            = aws_vpc.cka_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "cka_subnet_1"
  }
}

resource "aws_subnet" "cka_subnet_2" {
  vpc_id            = aws_vpc.cka_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "cka_subnet_2"
  }
}

resource "aws_subnet" "cka_subnet_3" {
  vpc_id            = aws_vpc.cka_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "cka_subnet_3"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "cka_igw" {
  vpc_id = aws_vpc.cka_vpc.id

  tags = {
    Name = "cka_igw"
  }
}

# Route Table
resource "aws_route_table" "cka_rt" {
  vpc_id = aws_vpc.cka_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cka_igw.id
  }

  tags = {
    Name = "cka_rt"
  }
}

resource "aws_route_table_association" "cka_rt_assoc_1" {
  subnet_id      = aws_subnet.cka_subnet_1.id
  route_table_id = aws_route_table.cka_rt.id
}

resource "aws_route_table_association" "cka_rt_assoc_2" {
  subnet_id      = aws_subnet.cka_subnet_2.id
  route_table_id = aws_route_table.cka_rt.id
}

resource "aws_route_table_association" "cka_rt_assoc_3" {
  subnet_id      = aws_subnet.cka_subnet_3.id
  route_table_id = aws_route_table.cka_rt.id
}




# 컨트롤 플레인 보안 그룹
resource "aws_security_group" "cka_sg_master" {
  name_prefix = "cka_sg_master"

  vpc_id = aws_vpc.cka_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10251
    to_port     = 10251
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10252
    to_port     = 10252
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cka_sg_worker" {
  name_prefix = "cka_sg_worker"

  vpc_id = aws_vpc.cka_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
