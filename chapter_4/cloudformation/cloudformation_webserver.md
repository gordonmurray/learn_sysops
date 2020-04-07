# Cloudformation Webserver

Create a simple webserver with Cloudformation

### Using Cloudformation to create a Stack using the AWS CLI

Before using the AWS CLI to create the Stack, you will need to know the values of each of the following that you would like to use

* VPC ID
* Subnet ID
* Key Pair name

```
aws cloudformation create-stack --stack-name webserver-cli --template-body file://webserver.yaml --parameters ParameterKey=KeyName,ParameterValue=[key pair name here] ParameterKey=SubnetID,ParameterValue=[ subnet value here ] ParameterKey=VPCIP,ParameterValue=[ VPC ID value here] --region us-east-1
```

If the command has executed properly, you will receive an output similar to the following:

```
{
"StackId": "arn:aws:cloudformation:us-east-1:123456789:stack/webserver-cli/12345-1111-2222-3333-1234567890"
}
```

If you would like to delete the stack afterwards, you can use the following

```
aws cloudformation delete-stack --stack-name webserver-cli --region us-east-1
```

