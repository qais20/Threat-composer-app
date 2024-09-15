# Define VPC
resource "aws_vpc" "tm_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tm-vpc"
  }
}

# Define Public Subnet 1
resource "aws_subnet" "tm_public_subnet_1" {
  vpc_id                  = aws_vpc.tm_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "tm-public-subnet-1"
  }
}

# Define Public Subnet 2
resource "aws_subnet" "tm_public_subnet_2" {
  vpc_id                  = aws_vpc.tm_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "tm-public-subnet-2"
  }
}

# Define Internet Gateway
resource "aws_internet_gateway" "tm_igw" {
  vpc_id = aws_vpc.tm_vpc.id
  tags = {
    Name = "tm-igw"
  }
}

# Define Route Table
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

# Route Table Association for Subnet 1
resource "aws_route_table_association" "tm_subnet1_rt_assoc" {
  subnet_id      = aws_subnet.tm_public_subnet_1.id
  route_table_id = aws_route_table.tm_public_rt.id
}

# Route Table Association for Subnet 2
resource "aws_route_table_association" "tm_subnet2_rt_assoc" {
  subnet_id      = aws_subnet.tm_public_subnet_2.id
  route_table_id = aws_route_table.tm_public_rt.id
}

# Define Security Group
resource "aws_security_group" "tm_ecs_sg" {
  name   = "tm-ecs-sg"
  vpc_id = aws_vpc.tm_vpc.id

  # Ingress Rules
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

  # Egress Rules
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