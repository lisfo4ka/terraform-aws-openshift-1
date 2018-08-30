resource "aws_security_group" "platform_public" {
  count = "${length(var.infra_public_security_group_ids) != 0 ? 0 : 1}"
  name  = "${var.platform_name}-platform-public"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.public_access_cidrs}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.public_access_cidrs}"]
  }

  ingress {
    from_port   = "30000"
    to_port     = "32767"
    protocol    = "tcp"
    cidr_blocks = ["${var.public_access_cidrs}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.platform_vpc_id}"

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-platform-public"))}"
}
