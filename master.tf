resource "aws_launch_configuration" "master" {
  name_prefix   = "${var.platform_name}-master-"
  image_id      = "${var.ami_id}"
  instance_type = "${var.master_instance_type}"
  ebs_optimized = true

  security_groups = [
    "${aws_security_group.node.id}",
  ]

  key_name             = "${aws_key_pair.platform.id}"
  user_data            = "${data.template_file.master_node_init.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.master.name}"
  spot_price           = "${var.upstream ? var.master_spot_price : ""}"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = true
  }

  # docker volume
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  # empty dir
  ebs_block_device {
    device_name = "/dev/sdg"
    volume_size = 50
    volume_type = "gp2"
  }
}

resource "aws_autoscaling_group" "master" {
  vpc_zone_identifier       = ["${var.private_subnet_ids}"]
  name                      = "${var.platform_name}-master"
  max_size                  = "${var.master_count}"
  min_size                  = "${var.master_count}"
  desired_capacity          = "${var.master_count}"
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.master.name}"

  # FIXME (will not work with internal deployment)
  target_group_arns = ["${aws_lb_target_group.master_secure.arn}"]

  load_balancers = ["${concat(aws_elb.master.*.name, aws_elb.master-public.*.name)}"]

  tag {
    key                 = "Name"
    value               = "${var.platform_name}-master"
    propagate_at_launch = true
  }

  tag {
    key                 = "cluster_role"
    value               = "master"
    propagate_at_launch = true
  }

  tag {
    key                 = "KubernetesCluster"
    value               = "${var.platform_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.platform_name}"
    value               = "${var.platform_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "SysName"
    value               = "EPAM"
    propagate_at_launch = true
  }

  tag {
    key                 = "SysOwner"
    value               = "marco.hernandez@regeneron.com"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "DEV"
    propagate_at_launch = true
  }

  tag {
    key                 = "CostCenter"
    value               = "0288"
    propagate_at_launch = true
  }

  tag {
    key                 = "BusinessUnit"
    value               = "RnD"
    propagate_at_launch = true
  }

  tag {
    key                 = "Department"
    value               = "Research Management and Operations"
    propagate_at_launch = true
  }

  tag {
    key                 = "Backup"
    value               = "True"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}
