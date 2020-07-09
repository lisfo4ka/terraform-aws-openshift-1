resource "aws_launch_configuration" "compute_node" {
  count         = "${length(var.compute_nodes)}"
  name_prefix   = "${var.platform_name}-compute-node-"
  image_id      = "${var.ami_id}"
  instance_type = "${lookup(var.compute_nodes[count.index], "instance_type")}"
  ebs_optimized = true

  security_groups = ["${coalescelist(var.cluster_internal_security_group_ids, aws_security_group.node.*.id)}"]

  key_name             = "${var.ssh_key_pair_name}"
  user_data            = "${data.template_file.node_init.rendered}"
  iam_instance_profile = "${var.create_iam_profiles ? coalesce(var.slave_node_iam_profile_name, join("",aws_iam_instance_profile.slave_node.*.name)) : var.slave_node_iam_profile_name}"
  spot_price           = "${var.compute_node_spot_price}"

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
    volume_size = 50
    volume_type = "gp2"
  }

  # empty dir
  ebs_block_device {
    device_name = "/dev/sdg"
    volume_size = 50
    volume_type = "gp2"
  }
}

resource "aws_autoscaling_group" "compute_node" {
  count = "${length(var.compute_nodes)}"

  vpc_zone_identifier = [
    "${slice(var.private_subnet_ids, 0, lookup(var.compute_nodes[count.index], "node_count") < length(var.private_subnet_ids) ? lookup(var.compute_nodes[count.index], "node_count") : length(var.private_subnet_ids))}",
  ]

  name                      = "${var.platform_name}-compute-node-${lookup(var.compute_nodes[count.index], "instance_type")}"
  max_size                  = "${lookup(var.compute_nodes[count.index], "node_count")}"
  min_size                  = "${lookup(var.compute_nodes[count.index], "node_count")}"
  desired_capacity          = "${lookup(var.compute_nodes[count.index], "node_count")}"
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = "${element(aws_launch_configuration.compute_node.*.name, count.index)}"
  suspended_processes       = ["${var.asg_suspended_processes}"]

  tag {
    key                 = "Name"
    value               = "${var.platform_name}-compute-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "cluster_role"
    value               = "node"
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
    value               = "${var.tags["SysName"]}"
    propagate_at_launch = true
  }

  tag {
    key                 = "SysOwner"
    value               = "${var.tags["SysOwner"]}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.tags["Environment"]}"
    propagate_at_launch = true
  }

  tag {
    key                 = "CostCenter"
    value               = "${var.tags["CostCenter"]}"
    propagate_at_launch = true
  }

  tag {
    key                 = "BusinessUnit"
    value               = "${var.tags["BusinessUnit"]}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Department"
    value               = "${var.tags["Department"]}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Backup"
    value               = "${var.tags["Backup"]}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}
