
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