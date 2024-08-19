# VPC
resource "aws_vpc" "sh_main" {
  cidr_block = var.vpc_cidr # 512 IPs 
  tags = {
    Name = var.vpc_name
  }
}

# Creating 1st subnet 
resource "aws_subnet" "sh_subnet_1" {
  vpc_id                  = aws_vpc.sh_main.id
  cidr_block              = var.public_subnet_az1_cidr #32 IPs
  map_public_ip_on_launch = true          # public subnet
  availability_zone       = var.az1
}
# Creating 2nd subnet 
resource "aws_subnet" "sh_subnet_1a" {
  vpc_id                  = aws_vpc.sh_main.id
  cidr_block              =  var.public_subnet_az2_cidr#32 IPs
  map_public_ip_on_launch = true           # public subnet
  availability_zone       = var.az2
}
# Creating 2nd subnet 
resource "aws_subnet" "sh_subnet_2" {
  vpc_id                  = aws_vpc.sh_main.id
  cidr_block              = var.private_subnet_az1_cidr #32 IPs
  map_public_ip_on_launch = false         # private subnet
  availability_zone       =var.az2
}
resource "aws_subnet" "sh_subnet_2a" {
  vpc_id                  = aws_vpc.sh_main.id
  cidr_block              = var.private_subnet_az2_cidr #32 IPs
  map_public_ip_on_launch = false         # private subnet
  availability_zone       =var.az1
}