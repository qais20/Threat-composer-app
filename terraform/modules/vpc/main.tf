resource "aws_vpc" "app-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "tm-subnet1" {
  vpc_id            = aws_vpc.app-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone_a

  tags = {
    Name = "tm-subnet"
  }
}


resource "aws_subnet" "tm-subnet2" {
  vpc_id            = aws_vpc.app-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone_b

  tags = {
    Name = "tm-subnet2"
  }
}

# Security Group Configuration

resource "aws_security_group" "tm-sg" {
  name   = var.security_group_name
  vpc_id = aws_vpc.app-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = var.security_group_name
  }
}


# # Configuring IGW
resource "aws_internet_gateway" "tm-igw" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = var.internet_gateway_name
  }
}

# # Egress-Only Internet Gateway for IPv6 traffic
resource "aws_egress_only_internet_gateway" "tm-igw" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = var.egress_internet_gateway_name
  }
}


# Configure route table

resource "aws_route_table" "tm-rt" {
  vpc_id = aws_vpc.app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tm-igw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.tm-igw.id
  }

  tags = {
    Name = "tm-rt"
  }
}

# Conifguring route table to be associated with subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.tm-subnet1.id
  route_table_id = aws_route_table.tm-rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.tm-subnet2.id
  route_table_id = aws_route_table.tm-rt.id
}
