resource "aws_security_group" "deployment" {
  name        = "${var.platform_name}-deployment"
  description = "Deployment node group for ${var.platform_name}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.operator_cidrs}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-deployment-node"))}"

  vpc_id = "${var.platform_vpc_id}"
}
