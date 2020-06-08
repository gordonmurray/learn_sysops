
# Describe AMIs named 'webserver'
aws ec2 describe-images \
    --owners self \
    --filters "Name=name,Values=webserver"

# Describe security group
aws ec2 describe-security-groups \
    --group-names webserver-security-group \
    --query 'SecurityGroups[*].{Group:GroupId}'

# Launch EC2 instance from an AMI
aws ec2 run-instances \
    --image-id ami-0f5337828f196dd15 \
    --instance-type t2.micro \
    --key-name ansible-webserver \
    --security-group-ids sg-08095a235a79de3d1 \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Webserver-CLI}]'

# Describe an instance and return its Public IP
aws ec2 describe-instances \
    --profile gordonmurray \
    --instance-id i-0f299502bbbb61cd0 \
    --query 'Reservations[*].Instances[*].NetworkInterfaces[*].Association.PublicIp'
