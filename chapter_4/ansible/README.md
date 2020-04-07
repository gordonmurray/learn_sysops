# Ansible webserver AWS

Using Ansible to create and configure a simple webserver on AWS

## Install Ansible

> sudo apt-get update

> sudo apt-get install software-properties-common -y

> sudo apt-add-repository --yes --update ppa:ansible/ansible

> sudo apt-get install ansible -y

## Create a Vault file with AWS credentials

> ansible-vault create group_vars/all/pass.yml

Include your AWS Key and Secret with permission to create EC2 resources

```
    ec2_access_key: [ your aws access key ]
    ec2_secret_key: [ your aws secret key ]
```

Create a second file with the following content to allow Ansible to connect to the EC2 instance(s) identified by their tags

> ansible-vault create aws_ec2.yml

With the following content:

```
plugin: aws_ec2
regions:
  - eu-west-1
filters:
  tag:Name: Webserver
aws_access_key_id: [ your aws access key ]
aws_secret_access_key: [ your aws secret key ]
```

## Dynamic Hosts

aws_ec2.yml is used to determine the host(s) to update based on the Region and a Tag added to the EC2 instance during creation.

## To create the AWS infrastructure items

> ansible-playbook playbook.yml --ask-vault-pass

## To configure the webserver once it has been created

> ansible-playbook -i aws_ec2.yml webserver.yml --ask-vault-pass

or

> ansible-playbook -i aws_ec2.yml webserver.yml --vault-password-file=vault_password

## Files

* 01_infrastructure.yml - this playbook will create an ec2 instance, a security group, and tag them.
* 02_webserver.yml - this playbook will call 2 two Roles, one to install Apache and one to install PHP
* aws_ec2.yml - This is an Ansible plugin. It is a Dynamic inventry source. It can query your EC2 account for Tagged instances, instead of hard coding instance IP addresses.
* group_vars/all/pass.yml - This files holds AWS crednetials so Ansible can connect to your AWS account
* roles/apache/files/webserver.conf - This is an Apache virtual host config file. It tells Apache where to look for your webserver files.
* roles/apache/tasks/main.yml - This is an Ansible task within a Role, to install Apache
* roles/deploy/tasks/main.yml - This is an Ansible task within a Role, to upload our /src folder to the webserver
* roles/ec2/tasks/main.yml - This is an Ansible task within a Role, to create an EC2 instance and Tag it.
* roles/keypair/tasks/main.yml - This is an Ansible task within a Role, to create and AWS Key Pair
* roles/php/tasks/main.yml - This is an Ansible task within a Role, to install PHP
* roles/securitygroup/tasks/main.yml - This is an Ansible task within a Role, to create a security group and Tag it.
* src/index.php - This is a sample PHP page we will upload to the Webserver
