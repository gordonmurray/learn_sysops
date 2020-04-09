# Get AMI
data "aws_ami" "webserver_ami" {
  most_recent = true

  filter {
    name = "name"

    values = ["webserver*"]
  }

  owners = ["${var.aws_account_id}"]
}

# Create EC2 instances
resource "aws_instance" "webserver" {
  ami                    = "${data.aws_ami.webserver_ami.id}"
  instance_type          = "${var.default_instance_type}"
  vpc_security_group_ids = ["${aws_security_group.example.id}"]
  subnet_id              = "${aws_subnet.subnet-1a.id}"
  key_name               = "${aws_key_pair.pem-key.key_name}"

  tags = {
    Name = "webserver"
  }
}

}
