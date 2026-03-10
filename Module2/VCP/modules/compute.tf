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

# EC2 Instances, one in the public subnet (bastion host) and one in the private subnet
resource "aws_instance" "bastion" {
    ami           = var.ami_id
    instance_type = var.instance_type
    associate_public_ip_address = true # Asignate a public IP to the bastion host

    subnet_id = aws_subnet.public.id

    vpc_security_group_ids = [
        aws_security_group.bastion_sg.id
    ]

    key_name = aws_key_pair.bastion.key_name

    tags = {
        Name = "bastion-host"
    }
}

resource "aws_instance" "private_ec2" {
    ami           = var.ami_id
    instance_type = var.instance_type

    subnet_id = aws_subnet.private.id

    vpc_security_group_ids = [
        aws_security_group.private_ec2_sg.id
    ]

    key_name = aws_key_pair.private_ec2.key_name

    tags = {
        Name = "private-server"
    }
}

