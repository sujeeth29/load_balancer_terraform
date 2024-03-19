# creating vpc
resource "aws_vpc" "My-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}
# creating a public subnet in AZ us-east-1a
resource "aws_subnet" "pub_east_1a" {
  vpc_id                  = aws_vpc.My-vpc.id
  cidr_block              = var.pub_subnet_az_1_cidr
  availability_zone       = var.az_1
  map_public_ip_on_launch = true
  tags = {
    Name = var.pub_subnet_name_az_1
  }
}
# creating a private subnet in AZ us-east-1a
resource "aws_subnet" "pri_east_1a" {
  vpc_id            = aws_vpc.My-vpc.id
  cidr_block        = var.pri_subnet_az_1_cidr
  availability_zone = var.az_1
  tags = {
    Name = var.pri_subnet_name_az_1
  }
}
# creating a public subnet in AZ us-east-1b
resource "aws_subnet" "pub_east_1b" {
  vpc_id                  = aws_vpc.My-vpc.id
  cidr_block              = var.pub_subnet_az_2_cidr
  availability_zone       = var.az_2
  map_public_ip_on_launch = true
  tags = {
    Name = var.pub_subnet_name_az_2
  }
}
# creating a public subnet in AZ us-east-1b
resource "aws_subnet" "pri_east_1b" {
  vpc_id            = aws_vpc.My-vpc.id
  cidr_block        = var.pri_subnet_az_2_cidr
  availability_zone = var.az_2
  tags = {
    Name = var.pri_subnet_name_az_2
  }
}

# creating a IGW and attaching it to vpc
resource "aws_internet_gateway" "My-igw" {
  vpc_id = aws_vpc.My-vpc.id
  tags = {
    Name = var.igw_name
  }
}
# allocating Elastic ip
resource "aws_eip" "nat-1" {
  vpc = true
}
# creating Nat-gate way for AZ us-east-1a
resource "aws_nat_gateway" "My-ngw-east-1a" {
  allocation_id = aws_eip.nat-1.id
  subnet_id     = aws_subnet.pub_east_1a.id
}
# allocating Elastic ip
resource "aws_eip" "nat-2" {
  vpc = true
}
# creating Nat-gate way for AZ us-east-1a
resource "aws_nat_gateway" "My-ngw-east-1b" {
  allocation_id = aws_eip.nat-2.id
  subnet_id     = aws_subnet.pub_east_1b.id
}
# creating public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.My-vpc.id
  route {
    cidr_block = var.all_cidr_ipv4
    gateway_id = aws_internet_gateway.My-igw.id
  }
}
# Associating public subnets to public route table
resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.pub_east_1a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.pub_east_1b.id
  route_table_id = aws_route_table.public.id
}
# creating private route table for  AZ east-1a
resource "aws_route_table" "Private-1a" {
  vpc_id = aws_vpc.My-vpc.id

  route {
    cidr_block     = var.all_cidr_ipv4
    nat_gateway_id = aws_nat_gateway.My-ngw-east-1a.id
  }
}

# associating subnet to Private-1a
resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.pri_east_1a.id
  route_table_id = aws_route_table.Private-1a.id
}
# creating private route table for  AZ east-1b
resource "aws_route_table" "Private-1b" {
  vpc_id = aws_vpc.My-vpc.id

  route {
    cidr_block     = var.all_cidr_ipv4
    nat_gateway_id = aws_nat_gateway.My-ngw-east-1b.id
  }
}

# associating subnet to Private-1a
resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.pri_east_1b.id
  route_table_id = aws_route_table.Private-1b.id
}
