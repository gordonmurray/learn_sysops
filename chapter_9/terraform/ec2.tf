# Search for Graylog AMI
data "aws_ami" "graylog_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["graylog*"]
  }

  owners = [var.aws_account_id]

}

# Read the user data from a template file
data "template_file" "user_data" {
  template = "userdata.tpl"
}

# Create EC2 instance
resource "aws_instance" "graylog" {
  ami                    = data.aws_ami.graylog_ami.id
  instance_type          = "m5.large"
  vpc_security_group_ids = [aws_security_group.graylog.id]
  key_name               = aws_key_pair.pem-key.key_name
  user_data              = file("userdata.txt")
  tags = {
    Name = "terraform-graylog"
  }
}

