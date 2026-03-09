/*
** Resume:
                     Internet
                        │
                 Internet Gateway
                        │
                Public Route Table
                        │
                  Public Subnet
                        │
                    NAT Gateway
                        │
               Private Route Table
                        │
                 Private Subnet
                        │
                    Servidores
*/


# Create a VPC with CIDR block and enable DNS support and hostnames
resource "aws_vpc" "mi_vpc" {
    cidr_block              = var.vpc_cidr
    instance_tenancy        = "default"
    enable_dns_support      = true
    enable_dns_hostnames    = true
    
    tags = {
        Name = "first-vpc"
    }
}

# Create a public subnet and a private subnet in the VPC
# The availability zones are specified to ensure that the
# subnets are created in different zones for high availability

resource "aws_subnet" "public" {
    vpc_id                  = aws_vpc.mi_vpc.id
    cidr_block              = var.public_subnet_cidr
    availability_zone       = "eu-west-1a"
    map_public_ip_on_launch = true
    
    tags = {
        Name = "public-subnet"
    }
}

resource "aws_subnet" "private" {
    vpc_id                  = aws_vpc.mi_vpc.id
    cidr_block              = var.private_subnet_cidr
    availability_zone       = "eu-west-1b"
    map_public_ip_on_launch = false
    
    tags = {
        Name = "private-subnet"
    }
}




# Create an internet gateway to allow communication between the VPC and the internet
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.mi_vpc.id

    tags = {
        Name = "internet-gateway"
    }
}

# Create a NAT gateway in the public subnet to allow instances 
# in the private subnet to access the internet
# Can got to the internet but CANNOT receive inbound traffic from the internet
resource "aws_nat_gateway" "nat" {
    allocation_id   = aws_eip.nat.id
    subnet_id       = aws_subnet.public.id

    tags = {
        Name = "nat-gateway"
    }
}

# Create an Elastic IP address for the NAT gateway
# An Elastic IP address is a static, public IPv4 address that can be 
# associated with an instance or a NAT gateway
resource "aws_eip" "nat" {
    # no arguments needed
}
