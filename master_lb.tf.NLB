# Endpoint for Master access

resource "aws_lb" "master" {
  name                             = "${var.platform_name}-master"
  internal                         = true
  subnets                          = ["${var.private_subnet_ids}"]
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-master-lb"))}"
}

resource "aws_lb_listener" "master_insecure" {
  load_balancer_arn = "${aws_lb.master.arn}"
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.master_insecure.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "master_insecure" {
  name                 = "${var.platform_name}-master-insecure"
  port                 = 80
  protocol             = "TCP"
  deregistration_delay = 20
  vpc_id               = "${var.platform_vpc_id}"
  tags                 = "${merge(var.tags, map("Name", "${var.platform_name}-master-insecure"))}"
}

resource "aws_lb_listener" "master-443" {
  load_balancer_arn = "${aws_lb.master.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.master-443.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "master-443" {
  name                 = "${var.platform_name}-master-443"
  port                 = 443
  protocol             = "TCP"
  deregistration_delay = 20
  vpc_id               = "${var.platform_vpc_id}"
  tags                 = "${merge(var.tags, map("Name", "${var.platform_name}-master-443"))}"
}

resource "aws_lb_listener" "master-8443" {
  load_balancer_arn = "${aws_lb.master.arn}"
  port              = "8443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.master-8443.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "master-8443" {
  name                 = "${var.platform_name}-master-8443"
  port                 = 8443
  protocol             = "TCP"
  deregistration_delay = 20
  vpc_id               = "${var.platform_vpc_id}"
  tags                 = "${merge(var.tags, map("Name", "${var.platform_name}-master-8443"))}"
}
