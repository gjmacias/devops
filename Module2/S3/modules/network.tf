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
    availability_zone       = var.availability_zone_public
    map_public_ip_on_launch = true
    
    tags = {
        Name = "public-subnet"
    }
}

resource "aws_subnet" "private" {
    vpc_id                  = aws_vpc.mi_vpc.id
    cidr_block              = var.private_subnet_cidr
    availability_zone       = var.availability_zone_private
    map_public_ip_on_launch = false
    
    tags = {
        Name = "private-subnet"
    }
}
