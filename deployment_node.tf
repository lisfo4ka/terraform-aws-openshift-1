data "template_file" "deployment_init" {
  count    = "${var.need_deployment_node}"
  template = "${file("${path.module}/resources/origin-deployment-init.yml")}"

  vars {
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"

    openshift_major_version = "${var.openshift_major_version}"
  }
}

locals {
  deployment_ssh_user = "${var.user_name}"
}

resource "aws_instance" "deployment" {
  count                       = "${var.need_deployment_node}"
  ami                         = "${var.ami_id}"
  instance_type               = "t2.small"
  subnet_id                   = "${var.private_subnet_ids[0]}"
  associate_public_ip_address = false
  key_name                    = "${var.ssh_key_pair_name}"

  vpc_security_group_ids = [
    "${coalescelist(var.cluster_internal_security_group_ids, concat(aws_security_group.deployment.*.id, aws_security_group.node.*.id))}",
  ]

  iam_instance_profile = "${var.create_iam_profiles ? coalesce(var.slave_node_iam_profile_name, join("",aws_iam_instance_profile.slave_node.*.name)) : var.deployment_node_iam_profile_name}"

  user_data = "${data.template_file.deployment_init.rendered}"

  tags = "${merge(var.tags, map(
    "Name", "${var.platform_name}-deployment",
    "Role", "deployment-node"
    ))}"
}
