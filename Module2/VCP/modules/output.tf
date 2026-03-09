# VPC ID
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.mi_vpc.id
}

# Public subnet ID
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

# Private subnet ID
output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

# Bastion host public IP
output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}

# Private EC2 instance ID
output "private_ec2_private_ip" {
  description = "Private IP of the private EC2 instance"
  value       = aws_instance.private_ec2.private_ip
}


# NAT Gateway public IP
output "nat_gateway_public_ip" {
  description = "Elastic IP associated with the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

# AMI used for the EC2 instances
output "ami_used" {
  description = "AMI used for the EC2 instances"
  value       = data.aws_ami.amazon_linux.id
}





# DEBUGGING PURPOSES ONLY

output "public_route_table_id" {
    description = "ID of the public route table"
    value = aws_route_table.public_rt.id
}

output "private_route_table_id" {
    description = "ID of the private route table"
    value = aws_route_table.private_rt.id
}





# SSH connection details for the bastion host
output "ssh_bastion_command" {
    description = "SSH command for connecting to the bastion host"
    value = "ssh -i ${aws_key_pair.bastion.key_name}.pem ec2-user@${aws_instance.bastion.public_ip}"
}