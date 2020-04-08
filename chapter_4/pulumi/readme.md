# Create a simple webserver on AWS usiung Pulumi and Python

Install some neccessary Python packages

```
sudo apt install python-dev -y
sudo apt install python3-pip -y
sudo apt install python3-venv -y
```

Create a new Stack

```
pulumi new aws-python --name webserver-pulumi --stack webserver
```

Once the stack files are created, use the follwing to create a virtual env and install requirements

```
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
```

To create or update the infrastructure, use:

```
pulumi up
```

If you're done with the stack and want to remove it use:

```
pulumi destroy
```