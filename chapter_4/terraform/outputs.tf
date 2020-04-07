output "public_dns" {
  description = "The EC2 instance DNS"
  value       = "${aws_instance.example.public_dns}"
}

output "security_group_id" {
  description = "The security group ID"
  value       = "${aws_security_group.example.id}"
}