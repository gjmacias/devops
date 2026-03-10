
# Create a public EC2 instance in the public subnet, which can be accessed from the internet.
resource "aws_instance" "public_ec2" {
    ami                         = var.ami_id
    instance_type               = var.instance_type

    associate_public_ip_address = true # Asignate a public IP

    subnet_id = aws_subnet.public.id

    vpc_security_group_ids = [
        aws_security_group.public_ec2_sg.id
    ]

    key_name = aws_key_pair.public_ec2.key_name

    tags = {
        Name = "public-server"
    }
}

