resource "aws_elb" "infra" {
  name     = "${var.platform_name}-infra-${var.internet_facing}"
  internal = "${var.internet_facing == "external" ? 0 : 1 }"
  subnets  = ["${split(",", var.internet_facing == "external" ? join(",", var.public_subnet_ids) : join(",", var.private_subnet_ids))}"]

  security_groups = ["${coalescelist(var.infra_public_security_group_ids, aws_security_group.platform_public.*.id)}"]

  access_logs {
    bucket        = "${aws_s3_bucket.elb_logs.bucket}"
    bucket_prefix = "infra"
    interval      = 5
  }

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-infra-internal"))}"

  listener {
    instance_port      = 443
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${aws_acm_certificate_validation.openshift-cluster.certificate_arn}"
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = "${var.gerrit_ssh_port}"
    instance_protocol = "tcp"
    lb_port           = "${var.gerrit_ssh_port}"
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
