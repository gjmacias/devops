# Module Infrastructure Outputs
output "vpc_id" {
description = "ID of the created VPC"
  value       = module.infra.vpc_id
}
output "public_subnet_ip" {
  description = "IP of the public subnet"
  value       = module.infra.public_subnet_ip
}
output "private_subnet_ip" {
  description = "IP of the private subnet"
  value       = module.infra.private_subnet_ip
}

output "public_ec2_public_ip" {
    description = "Public IP of the public EC2 instance"
    value       = module.infra.public_ec2_public_ip
}
output "ami_used" {
  description = "AMI used for the EC2 instances"
  value       = data.aws_ami.amazon_linux.id
}

output "bucket_id" {
  description = "ID of the created S3 bucket for Terraform state"
  value       = var.s3_bucket_name
}