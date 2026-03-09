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

# region AWS VPC with Terraform
provider "aws" {
    region = "eu-west-1"
}

# Create a VPC with CIDR block and enable DNS support and hostnames
resource "aws_vpc" "mi_vpc" {
    cidr_block              = "10.0.0.0/16"
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
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "eu-west-1a"
    map_public_ip_on_launch = true
    
    tags = {
        Name = "public-subnet"
    }
}

resource "aws_subnet" "private" {
    vpc_id                  = aws_vpc.mi_vpc.id
    cidr_block              = "10.0.2.0/24"
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
    vpc = true
}


# Create a route table for the public subnet and associate it with the subnet
# The route table has a route to the internet gateway for all traffic 
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.mi_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "public-route-table"
    }
}

# Associate the public route table with the public subnet
resource "aws_route_table_association" "public_assoc" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
}

# Create a route table for the private subnet and associate it with the subnet
# The route table has a route to the NAT gateway for all traffic
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.mi_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_assoc" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.private_rt.id
}


# Create a security group for the bastion host in the public subnet
# The security group allows inbound traffic on port 22 from any IP address
resource "aws_security_group" "bastion_sg" {
    name        = "bastion-sg"
    description = "Allow SSH from internet"
    vpc_id      = aws_vpc.mi_vpc.id

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
        Name = "bastion-sg"
    }
}

# Create a security group to allow SSH inbound traffic to the instances in the private subnet
# The security group allows inbound traffic on port 22 from any IP 
# address and allows all outbound traffic
resource "aws_security_group" "private_ec2_sg" {
    name        = "private_ec2_sg"
    description = "Allow SSH, HTTP, HTTPS"
    vpc_id      = aws_vpc.mi_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
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
        Name = "private_ec2_sg"
    }
}

# Network ACLs (Access Control Lists) 
# are an additional layer of security that can be used to control
# traffic to and from subnets in a VPC. Create a network ACL for the private 
# subnet to allow SSH and HTTPS inbound traffic and allow all outbound traffic

#    Internet
#       │
#    IGW
#       │
#    Route Table
#       │
#    NACL (allowed?)
#       │
#    Security Group (allowed?)
#       │
#    EC2  

resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.mi_vpc.id

  tags = {
    Name = "private-nacl"
  }
}

# inbound rules

# Allow SSH from the public subnet (or from the internet if you want to allow SSH access from anywhere)
resource "aws_network_acl_rule" "inbound_ssh" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "10.0.1.0/24" # IPs de tu subnet pública
  from_port      = 22
  to_port        = 22
}


# Allow HTTP from the public subnet (or from the internet if you want to allow HTTP access from anywhere)
resource "aws_network_acl_rule" "inbound_http" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "10.0.1.0/24" # IPs de tu subnet pública
  from_port      = 80
  to_port        = 80
}

# Allow HTTPS from the public subnet (or from the internet if you want to allow HTTPS access from anywhere)
resource "aws_network_acl_rule" "inbound_https" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 120
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Block all other inbound traffic to the private subnet
resource "aws_network_acl_rule" "inbound_deny_all" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 200
  egress         = false
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# outbound rules

# Allow all outbound traffic from the private subnet to the internet
resource "aws_network_acl_rule" "outbound_allow_all" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}


            #     Internet
            #         │
            #  Internet Gateway
            #         │
            # ┌───────────────┐
            # │ Public Subnet │
            # │               │
            # │  Bastion EC2  │
            # │               │
            # │  NAT Gateway  │
            # └───────┬───────┘
            #         │
            # ┌───────▼───────┐
            # │ Private Subnet│
            # │               │
            # │   EC2 privada │
            # │               │
            # │  NACL rules   │
            # └───────────────┘

resource "aws_instance" "bastion" {
    ami           = "ami-0c94855ba95c71c99" # Amazon Linux 
    instance_type = "t2.micro"
    associate_public_ip_address = true # Asignate a public IP to the bastion host

    subnet_id = aws_subnet.public.id

    vpc_security_group_ids = [
        aws_security_group.bastion_sg.id
    ]

    key_name = "mi-clave-ssh"

    tags = {
        Name = "bastion-host"
    }
}


resource "aws_instance" "private_ec2" {
    ami           = "ami-0c94855ba95c71c99"
    instance_type = "t2.micro"

    subnet_id = aws_subnet.private.id

    vpc_security_group_ids = [
        aws_security_group.private_ec2_sg.id
    ]

    key_name = "mi-clave-ssh"

    tags = {
        Name = "private-server"
    }
}