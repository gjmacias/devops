# region AWS VPC with Terraform
provider "aws" {
    region = var.aws_region
}

# Search for the latest Amazon Linux 2023 AMI in the specified region
# Name: al2023-ami-*-x86_64 -> Amazon Linux 2023 AMI with 
# HVM virtualization
# EBS root device
# x86_64 architecture
data "aws_ami" "amazon_linux" {
    provider    = aws
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["al2023-ami-*-x86_64"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }
}


# Create a module to create the VPC, subnets, internet gateway, NAT gateway, route tables, and security groups
# The module will be called "infra" and will be located in the "modules" directory
# The module will take the following variables as input
module "infra" {
    source  = "./modules"

    ami_id                      = data.aws_ami.amazon_linux.id
    aws_region                  = var.aws_region
    availability_zone_public    = var.availability_zone_public
    availability_zone_private   = var.availability_zone_private    
    instance_type               = var.instance_type
    vpc_cidr                    = var.vpc_cidr
    public_subnet_cidr          = var.public_subnet_cidr
    private_subnet_cidr         = var.private_subnet_cidr
    bastion_key_pair_name       = var.bastion_key_pair_name
    private_ec2_key_pair_name   = var.private_ec2_key_pair_name
}