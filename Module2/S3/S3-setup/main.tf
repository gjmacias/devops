# region AWS VPC with Terraform
provider "aws" {
    region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = var.s3_bucket_name

    force_destroy = true # Delete the bucket even if it contains objects

    tags = {
        Name = "Terraform State"
    }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}