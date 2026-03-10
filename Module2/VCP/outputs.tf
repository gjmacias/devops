# Module Infrastructure Outputs
output "vpc_id" {
    description = "ID of the created VPC"
  value       = module.infra.vpc_id
}
output "public_subnet_id" {
    description = "ID of the public subnet"
  value       = module.infra.public_subnet_id
}
output "private_subnet_id" {
    description = "ID of the private subnet"
  value       = module.infra.private_subnet_id
}
output "bastion_public_ip" {
    description = "Public IP of the bastion host"
  value       = module.infra.bastion_public_ip
}
output "private_ec2_private_ip" {
    description = "Private IP of the private EC2 instance"
  value       = module.infra.private_ec2_private_ip
}
output "nat_gateway_public_ip" {
  description = "Elastic IP associated with the NAT Gateway"
  value       = module.infra.nat_gateway_public_ip
}
output "ami_used" {
  description = "AMI used for the EC2 instances"
  value       = data.aws_ami.amazon_linux.id
}
# DEBUGGING PURPOSES ONLY
output "public_route_table_id" {
    description = "ID of the public route table"
    value = module.infra.public_route_table_id
}
output "private_route_table_id" {
    description = "ID of the private route table"
    value = module.infra.private_route_table_id
}
# SSH connection details for the bastion host
output "ssh_bastion_command" {
    description = "SSH command for connecting to the bastion host"
    value = "ssh -i ${module.infra.bastion_private_key_path} ec2-user@${module.infra.bastion_public_ip}"
}

# SSH connection details for the private EC2 instance via the bastion host
output "ssh_private_ec2_command" {
  description = "SSH command for connecting to the private EC2 via bastion"
  value = <<EOT
  ssh -i ${module.infra.private_ec2_private_key_path} \
  -o ProxyCommand="ssh -i ${module.infra.bastion_private_key_path} -W %h:%p ec2-user@${module.infra.bastion_public_ip}" \
  ec2-user@${module.infra.private_ec2_private_ip}
  EOT
}