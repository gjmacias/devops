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