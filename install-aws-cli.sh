#!/bin/bash 

# Install AWS CLI sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

# 1️⃣ aws configure
# 2️⃣ terraform init
# 3️⃣ terraform plan
# 4️⃣ terraform apply
# 5️⃣ ssh al bastion
# 6️⃣ ssh a la private ec2

# Get sudo privileges

sudo -v

# Add the AWS CLI GPG key and repository
# The GPG key is used to verify the authenticity of the packages

curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
unzip awscliv2.zip
sudo ./aws/install