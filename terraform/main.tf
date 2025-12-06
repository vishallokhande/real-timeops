provider "aws" {
  region = "ap-south-1" # change as needed
}

resource "aws_vpc" "rt_vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "real-timeops-vpc" }
}

resource "aws_subnet" "rt_subnet" {
  vpc_id            = aws_vpc.rt_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags              = { Name = "real-timeops-subnet" }
}

resource "aws_security_group" "rt_sg" {
  name   = "real-timeops-sg"
  vpc_id = aws_vpc.rt_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.rt_subnet.id
  vpc_security_group_ids      = [aws_security_group.rt_sg.id]
  key_name                    = "november_key" # must exist in AWS
  associate_public_ip_address = true
  tags                        = { Name = "november_key" }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20251022"]
  }
}

