resource "aws_vpc" "tm_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tm-vpc"
  }
}


resource "aws_subnet" "tm_public_subnet_1" {
  vpc_id                  = aws_vpc.tm_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "tm-public-subnet-1"
  }
}

resource "aws_subnet" "tm_public_subnet_2" {
  vpc_id                  = aws_vpc.tm_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "tm-public-subnet-2"
  }
}

resource "aws_internet_gateway" "tm_igw" {
  vpc_id = aws_vpc.tm_vpc.id
  tags = {
    Name = "tm-igw"
  }
}

resource "aws_route_table" "tm_public_rt" {
  vpc_id = aws_vpc.tm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tm_igw.id
  }

  tags = {
    Name = "tm-public-rt"
  }
}

resource "aws_route_table_association" "tm_subnet1_rt_assoc" {
  subnet_id      = aws_subnet.tm_public_subnet_1.id
  route_table_id = aws_route_table.tm_public_rt.id
}

resource "aws_route_table_association" "tm_subnet2_rt_assoc" {
  subnet_id      = aws_subnet.tm_public_subnet_2.id
  route_table_id = aws_route_table.tm_public_rt.id
}

resource "aws_security_group" "tm_ecs_sg" {
  name   = "tm-ecs-sg"
  vpc_id = aws_vpc.tm_vpc.id

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
    Name = "tm-ecs-sg"
  }
}