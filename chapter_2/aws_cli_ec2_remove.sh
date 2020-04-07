#
# Cleaning up
# Only run the following items if you wish to remove the items created above.
#

# Get the instance ID of the EC2 instance
INSTANCE_ID=`aws ec2 describe-instances --filter "Name=tag:Name,Values=example" --region eu-west-1 --query 'Reservations[].Instances[].[InstanceId]' --output text`

# delete the EC2 instance
aws ec2 terminate-instances --region ${REGION} --instance-ids ${INSTANCE_ID}

# Sleep to give the instance time to terminate
sleep 60

# delete security group
aws ec2 delete-security-group --region ${REGION} --group-name ${SECURITY_GROUP_NAME}

# delete the key pair from AWS
aws ec2 delete-key-pair --region ${REGION} --key-name ${KEY_PAIR_NAME}

# delete the key pair from the local folder
rm ${KEY_PAIR_NAME}.pem