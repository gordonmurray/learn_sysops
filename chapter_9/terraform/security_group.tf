resource "aws_security_group" "graylog" {
  name        = "graylog"
  description = "graylog security group"

  tags = {
    Name = "terraform-graylog"
  }
}

