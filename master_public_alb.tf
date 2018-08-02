resource "aws_lb" "master-alb" {
  count                            = "${var.internet_facing == "external" ? 1 : 0 }"
  name                             = "${var.platform_name}-master-alb"
  internal                         = false
  subnets                          = ["${var.public_subnet_ids}"]
  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true

  security_groups = [
    "${aws_security_group.node.id}",
    "${aws_security_group.master_public.id}",
  ]

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-master-alb"))}"
}

resource "aws_lb_listener" "master_secure" {
  count             = "${var.internet_facing == "external" ? 1 : 0 }"
  load_balancer_arn = "${aws_lb.master-alb.arn}"
  port              = "8443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate_validation.openshift-cluster.certificate_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.master_secure.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "master_secure" {
  count                = "${var.internet_facing == "external" ? 1 : 0 }"
  name                 = "${var.platform_name}-master-secure"
  port                 = 8443
  protocol             = "HTTPS"
  deregistration_delay = 20
  vpc_id               = "${var.platform_vpc_id}"
  tags                 = "${merge(var.tags, map("Name", "${var.platform_name}-master-secure"))}"

  stickiness = {
    type = "lb_cookie"
  }
}
