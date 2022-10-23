terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "My VPC"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Private 1"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Public 1"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "IGW VPC"
  }
}

resource "aws_route_table" "Route_public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Route Table IGW"
  }
}

resource "aws_route_table_association" "Public_route" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.Route_public.id
}

resource "aws_security_group" "SSh_HTTP_security" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    
  }

  tags = {
    Name = "HTTP and SSH Security"
  }
}

resource "aws_s3_bucket" "corona-api" {
  bucket = "covid-data-s3bucket"
  tags = {
    Description = "Bucket for corona api"
  }
}
resource "aws_s3_bucket_object" "corona-api-script" {
  content = "sdk_friday_21-10/mysdkcorona/covid_test_apply.py"
  key = "covid_test_apply.py"
  bucket = aws_s3_bucket.corona-api.id
}
resource "aws_s3_bucket" "acl" {
  bucket = "ovid-data-s3bucket"
  acl    = "public-read"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_instance" "my_sdktfec2" {

  ami           = "ami-0d593311db5abb72b"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.SSh_HTTP_security.id]
   key_name      = "vockey"
  user_data = file("userdata.sh")
  tags = {
    Name = "My sdkTFec2"
  }
}

