resource "aws_security_group" "example" {
  name        = "example"
  description = "example security group"

  tags = {
    Name = "terraform-webserver"
  }
}
