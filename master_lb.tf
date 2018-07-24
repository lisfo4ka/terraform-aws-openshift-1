resource "aws_elb" "master" {
  name     = "${var.platform_name}-master-internal"
  internal = true
  subnets  = ["${var.private_subnet_ids}"]

  security_groups = [
    "${aws_security_group.node.id}",
  ]

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-master-internal"))}"

  listener {
    instance_port     = 8443
    instance_protocol = "tcp"
    lb_port           = 8443
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

resource "aws_elb" "master-public" {
  count    = "${var.internet_facing == "external" ? 1 : 0 }"
  name     = "${var.platform_name}-master-external"
  internal = false
  subnets  = ["${var.public_subnet_ids}"]

  security_groups = [
    "${aws_security_group.node.id}",
    "${aws_security_group.master_public.id}",
  ]

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-master-external"))}"

  listener {
    instance_port     = 8443
    instance_protocol = "tcp"
    lb_port           = 8443
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
