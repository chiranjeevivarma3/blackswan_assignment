# creates VPC
resource "aws_vpc" "demo" {
  cidr_block              =  ("10.0.0.0/16")
  enable_dns_hostnames    = true
  enable_dns_support   = true
  tags = {
    Name = "demo-vpc"
  }
}
# creates private Subnets in the VPC
resource "aws_subnet" "private" {
  count = length(var.subnets_cidr)
  vpc_id = aws_vpc.demo.id
  cidr_block = element(var.subnets_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  tags = {
    Name = "demo-private-subnet-${count.index+1}"
  }
}
# creates public Subnet in the VPC
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "demo-public-subnet-3"
  }
}
# creates internet gateway in the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "demo-igw"
  }
}
# creates route table for private subnet
resource "aws_route_table" "private_rt" { 
  vpc_id = aws_vpc.demo.id 
  route { 
    cidr_block = "0.0.0.0/0" 
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }  
  tags = { 
    Name = "demo-private-routetable" 
  } 
} 
# creates route table for public subnet
resource "aws_route_table" "public_rt" {  
  vpc_id = aws_vpc.demo.id 
  route { 
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.igw.id 
  } 
  tags = { 
    Name = "demo-public-routetable" 
  } 
} 
# Route table association to public subnet
resource "aws_route_table_association" "public" { 
  subnet_id      = aws_subnet.public.id 
  route_table_id = aws_route_table.public_rt.id 
} 
# Route table association with private subnets
resource "aws_route_table_association" "private" {
  count = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.private.*.id,count.index)
  route_table_id = aws_route_table.private_rt.id
}
# creates elastic ip address for nat gateway
resource "aws_eip" "nateIP" {
   vpc   = true
 }
# creates Nat gateway for private subnets
resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id =  aws_subnet.public.id
 }