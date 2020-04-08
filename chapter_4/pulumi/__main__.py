import pulumi
import pulumi_aws as aws

# Define some variables to use in the stack
size = "t2.micro"
vpc_id = "vpc-xxxxxx"
subnet_id = "subnet-xxxxxx"
public_key = "ssh-rsa xxxxxxxxxxx"
user_data = """#!/bin/bash
sudo apt update
sudo apt install apache2 -y
echo 'Hello World!' > /var/www/html/index.html"""

# Get the AMI ID of the latest Ubuntu 18.04 version from Canonical
ami = aws.get_ami(
    most_recent="true",
    owners=["099720109477"],
    filters=[
        {
            "name": "name",
            "values": ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"],
        }
    ],
)

# Create an AWS Key Pair
keypair = aws.ec2.KeyPair(
    "keypair-pulumi",
    key_name="keypair-pulumi",
    public_key=public_key,
    tags={"Name": "keypair-pulumi"},
)

# Create an AWS Security group with ingress and egress rules
group = aws.ec2.SecurityGroup(
    "securitygroup-pulumi",
    description="Enable access",
    vpc_id=vpc_id,
    ingress=[
        {
            "protocol": "tcp",
            "from_port": 22,
            "to_port": 22,
            "cidr_blocks": ["0.0.0.0/0"],
        },
        {
            "protocol": "tcp",
            "from_port": 80,
            "to_port": 80,
            "cidr_blocks": ["0.0.0.0/0"],
        },
    ],
    egress=[
        {"protocol": "-1", "from_port": 0, "to_port": 0, "cidr_blocks": ["0.0.0.0/0"],}
    ],
    tags={"Name": "securitygroup-pulumi"},
)

# Create the webserver EC2 instance
server = aws.ec2.Instance(
    "webserver-pulumi",
    instance_type=size,
    vpc_security_group_ids=[group.id],
    user_data=user_data,
    ami=ami.id,
    key_name=keypair.key_name,
    subnet_id=subnet_id,
    tags={"Name": "webserver-pulumi"},
)

# Show the Public IP address of the webserver EC2 instance
pulumi.export("publicIp", server.public_ip)
