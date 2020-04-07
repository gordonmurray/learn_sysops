#!/usr/bin/env bash 

# The following assumes you have an AWS account with the AWS CLI installed locally
# It will ask which VPC and Subnets to use

# Show the commands being executed
set -ex

# AWS region
REGION="eu-west-1"
# Ubuntu Server 18.04 TLS
AMI_ID=02df9ea15c1778c9c
# Instance Type
INSTANCE_TYPE="t2.nano"
# Key Pair name to create
KEY_PAIR_NAME=example
# Security group name
SECURITY_GROUP_NAME=example
# Security group ID
# Leave this value blank as it will be populated later 
SECURITY_GROUP_ID=""
# Subnet ID to use
# Leave this value blank as it will be populated later
SUBNET_ID=""
# VPC ID to use
# Leave this value blank as it will be populated later
VPC_ID=""
# Determine current IP address
MY_IP_ADDRESS=`curl https://www.canihazip.com/s`

#
# No need to change anything beyond this point
#

# List existing VPCs
aws ec2 describe-vpcs --region ${REGION} --query 'Vpcs[*].VpcId'

# Read in the users VPC choice
echo "please chose the VPC to use:"
read VPC_ID

# List existing Subnets in the chosen VPC
aws ec2 describe-subnets --region ${REGION} --query 'Subnets[*].SubnetId' --filters "Name=vpc-id,Values=${VPC_ID}"

# Read in the users Subnet choice
echo "Please enter a Subnet ID to use from the above list:"
read SUBNET_ID

# Create a Security Group
aws ec2 create-security-group --region ${REGION} --group-name ${SECURITY_GROUP_NAME} --description "For an example EC2 instance"

# Add rule to the security group to allow port 80 open to all
aws ec2 authorize-security-group-ingress --region ${REGION} --group-name ${SECURITY_GROUP_NAME} --to-port 80 --ip-protocol tcp --cidr-ip 0.0.0.0/0 --from-port 80

# Add a rule to the security group to allow port 22 open to this machine
aws ec2 authorize-security-group-ingress --region ${REGION} --group-name ${SECURITY_GROUP_NAME} --to-port 22 --ip-protocol tcp --cidr-ip ${MY_IP_ADDRESS}/32 --from-port 22

# Get the security group ID
SECURITY_GROUP_ID=`aws ec2 describe-security-groups --region ${REGION} --group-names ${SECURITY_GROUP_NAME} --query 'SecurityGroups[*].[GroupId]' --output text`

# Create key pair .pem key file and save a local copy of it
aws ec2 create-key-pair --region ${REGION} --key-name ${KEY_PAIR_NAME} --query 'KeyMaterial' --output text > ${KEY_PAIR_NAME}.pem

# Create an EC2 instance
aws ec2 run-instances --region ${REGION} --image-id ami-${AMI_ID} --count 1 --instance-type ${INSTANCE_TYPE} --key-name ${KEY_PAIR_NAME} --security-group-ids ${SECURITY_GROUP_ID} --subnet-id ${SUBNET_ID}  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=example}]'

# sleep for a while to give the server time to start
sleep 60

# Get the instance public DNS name
PUBLIC_DNS=`aws ec2 describe-instances --filter "Name=tag:Name,Values=example" --region ${REGION} --query 'Reservations[].Instances[].[PublicDnsName]' --output text | head -2 | tail -1`

# Set permissions for the pem key
sudo chmod 600 ${KEY_PAIR_NAME}.pem

# Copy an index.html file to the server 
scp -i ${KEY_PAIR_NAME}.pem index.html ubuntu@${PUBLIC_DNS}:/home/ubuntu

# Connect to the EC2 instance, update it, install Apache and move the index file in to place
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@${PUBLIC_DNS} -i ${KEY_PAIR_NAME}.pem "sudo apt update && sudo apt install apache2 -y && sudo mv /home/ubuntu/index.html /var/www/html/index.html"

curl ${PUBLIC_DNS}

exit