resource "aws_elb" "master" {
  name     = "${var.platform_name}-master-internal"
  internal = true
  subnets  = ["${var.private_subnet_ids}"]

  idle_timeout = 300

  security_groups = ["${coalescelist(var.cluster_internal_security_group_ids, aws_security_group.node.*.id)}"]

  access_logs {
    bucket        = "${aws_s3_bucket.elb_logs.bucket}"
    bucket_prefix = "master-private"
    interval      = 5
  }

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-master-internal", "user:tag", "EDP-shared-${var.platform_name}"))}"

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
