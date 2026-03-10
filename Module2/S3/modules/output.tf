# VPC ID
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.mi_vpc.id
}

# Public subnet IP
output "public_subnet_ip" {
  description = "IP of the public subnet"
  value       = aws_subnet.public.cidr_block
}

# Private subnet IP
output "private_subnet_ip" {
  description = "IP of the private subnet"
  value       = aws_subnet.private.cidr_block
}

# Private EC2 instance ID
output "public_ec2_public_ip" {
  description = "Public IP of the public EC2 instance"
  value       = aws_instance.public_ec2.public_ip
}

# AMI used for the EC2 instances
output "ami_used" {
  description = "AMI used for the EC2 instances"
  value       = var.ami_id
}