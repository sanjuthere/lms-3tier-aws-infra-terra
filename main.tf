provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Main-VPC"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name = "Public-Subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name = "Private-Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Internet-Gateway"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public-RouteTable"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Groups
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "Public-SG"
  }
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public.cidr_block]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Private-SG"
  }
}

# EC2 Instances
resource "aws_instance" "frontend" {
  ami           = "ami-0c02fb55956c7d316" # Replace with the desired AMI ID
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  key_name      = var.key_name
  security_groups = [
    aws_security_group.public_sg.name
  ]
  tags = {
    Name = "Frontend-Server"
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-0c02fb55956c7d316" # Replace with the desired AMI ID
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private.id
  key_name      = var.key_name
  security_groups = [
    aws_security_group.private_sg.name
  ]
  tags = {
    Name = "Backend-Server"
  }
}

# Internal Load Balancer
resource "aws_lb" "internal" {
  name               = "lb-internal-app"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_sg.id]
  subnets            = [aws_subnet.private.id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "backend" {
  name        = "backend-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

resource "aws_lb_target_group_attachment" "backend_attachment" {
  target_group_arn = aws_lb_target_group.backend.arn
  target_id        = aws_instance.backend.id
  port             = 8080
}
