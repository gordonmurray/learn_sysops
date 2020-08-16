resource "aws_security_group_rule" "graylog_http" {
  type              = "ingress"
  from_port         = 9000
  to_port           = 9000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.graylog.id
  description       = "Public HTTP"
}

resource "aws_security_group_rule" "graylog_elasticsearch" {
  type              = "ingress"
  from_port         = 9200
  to_port           = 9200
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.graylog.id
  description       = "Public HTTP"
}

resource "aws_security_group_rule" "graylog_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.my_ip_address}/32"]
  security_group_id = aws_security_group.graylog.id
  description       = "SSH access"
}

resource "aws_security_group_rule" "graylog_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.graylog.id
  description       = "Allow all out"
}

resource "aws_security_group_rule" "graylog_udp" {
  type              = "ingress"
  from_port         = 13300
  to_port           = 13400
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.graylog.id
  description       = "Allow Graylog logs in"
}

