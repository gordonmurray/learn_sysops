data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# Create EC2 instance
resource "aws_instance" "example" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["${aws_security_group.example.id}"]
  key_name               = "${aws_key_pair.pem-key.key_name}"

  tags = {
    Name = "terraform-webserver"
  }

 provisioner "file" {
    // upload the index.html file
    source      = "files/index.html"
    destination = "/home/ubuntu/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install apache2 -y",
      "sudo mv /home/ubuntu/index.html /var/www/html/index.html"
    ]
  }

  connection {
    // connect over ssh
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
    timeout     = "1m"
    port        = "22"
    host        = "${aws_instance.example.public_dns}"
  }

}
