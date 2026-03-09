
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