output "public_dns" {
  description = "Graylog Public DNS address"
  value       = "${aws_instance.graylog.public_dns}:9000"
}

