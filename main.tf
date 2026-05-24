provider "aws" {
  region = "ap-south-1"
}

# ---------------- VPC ----------------

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "trend-vpc"
  }
}

# ---------------- Subnet ----------------

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "trend-subnet"
  }
}

# ---------------- Internet Gateway ----------------

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "trend-igw"
  }
}

# ---------------- Route Table ----------------

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

# ---------------- Security Group ----------------

resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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
}

# ---------------- EC2 Instance ----------------

resource "aws_instance" "jenkins" {
  ami                         = "ami-03f4878755434977f"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  key_name = "jenkins-key"

  tags = {
    Name = "jenkins-server"
  }
}