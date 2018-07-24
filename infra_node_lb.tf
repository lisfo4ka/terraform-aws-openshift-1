resource "aws_elb" "infra" {
  name     = "${var.platform_name}-infra-${var.internet_facing}"
  internal = "${var.internet_facing == "external" ? 0 : 1 }"
  subnets  = ["${split(",", var.internet_facing == "external" ? join(",", var.public_subnet_ids) : join(",", var.private_subnet_ids))}"]

  security_groups = [
    "${local.infra_security_groups}"
  ]

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-infra-internal"))}"

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:22"
    interval            = 30
  }
}

locals {
  infra_security_groups_internal = [
    "${aws_security_group.node.id}",
  ]

  infra_security_groups_external = [
    "${aws_security_group.node.id}",
    "${aws_security_group.platform_public.id}",
  ]

  infra_security_groups = [
    "${split(",", var.internet_facing == "external" ? join(",", local.infra_security_groups_external) : join(",", local.infra_security_groups_internal))}",
  ]
}
