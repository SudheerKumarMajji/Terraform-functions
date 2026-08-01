#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {

  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "sudheer-test-bucket-workspaces"
    key    = "workspace.tfstate"
    region = "us-east-1"
  }
}


resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name  = var.vpc_name
    Owner = "Sudheer"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

resource "aws_subnet" "public-subnet" {
  count             = length(var.public_cidr) #3
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_cidr[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "public-subnet${count.index + 1}"
  }
}

resource "aws_subnet" "private-subnet" {
  count             = length(var.private_cidr) # 3
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subnet${count.index + 1}"
  }
}


resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rtb"
  }
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.vpc_name}-private-rtb"
  }
}

# resource "aws_route_table_association" "terraform-public" {
#   subnet_id      = aws_subnet.subnet1-public.id
#   route_table_id = aws_route_table.terraform-public.id
# }

