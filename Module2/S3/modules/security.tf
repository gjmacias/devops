# Create a security group to allow SSH inbound traffic to the instances in the public subnet
# The security group allows inbound traffic on port 22 from any IP 
# address and allows all outbound traffic
resource "aws_security_group" "public_ec2_sg" {
    name        = "public_ec2_sg"
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
        Name = "public_ec2_sg"
    }
}