resource "aws_lb" "master-alb" {
  count                            = "${var.internet_facing == "external" ? 1 : 0 }"
  name                             = "${var.platform_name}-master-alb"
  internal                         = false
  subnets                          = ["${var.public_subnet_ids}"]
  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true

  security_groups = [
    "${coalescelist(concat(var.cluster_internal_security_group_ids, var.master_public_security_group_ids), concat(aws_security_group.master_public.*.id, aws_security_group.node.*.id))}",
  ]

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-master-alb"))}"
}

resource "aws_lb_listener" "master_secure" {
  count             = "${var.internet_facing == "external" ? 1 : 0 }"
  load_balancer_arn = "${aws_lb.master-alb.arn}"
  port              = "${var.master_public_lb_port}"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${coalesce(var.certificate_arn, join("",aws_acm_certificate_validation.openshift-cluster.*.certificate_arn))}"

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

# with internal deployment we need to use the below ELB
resource "aws_elb" "master-public" {
  count    = "${var.internet_facing == "external" ? 0 : 1 }"
  name     = "${var.platform_name}-master-external"
  internal = false
  subnets  = ["${var.public_subnet_ids}"]

  security_groups = ["${coalescelist(var.master_public_security_group_ids, aws_security_group.master_public.*.id)}"]

  access_logs {
    bucket        = "${aws_s3_bucket.elb_logs.bucket}"
    bucket_prefix = "master-public"
    interval      = 5
  }

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
