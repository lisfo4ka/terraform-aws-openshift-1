data "template_file" "deployment_init" {
  count    = "${var.deployer}"
  template = "${(var.upstream) ? file("${path.module}/resources/origin-deployment-init.yml") : file("${path.module}/resources/deployment-init.yml")}"

  vars {
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"

    openshift_major_version = "${var.openshift_major_version}"
  }
}

locals {
  deployment_ssh_user = "${(var.upstream) ? "centos" : "ec2-user"}"
}

resource "aws_instance" "deployment" {
  count                       = "${var.deployer}"
  ami                         = "${var.ami_id}"
  instance_type               = "t2.small"
  subnet_id                   = "${var.public_subnet_ids[0]}"
  associate_public_ip_address = false
  key_name                    = "${var.ssh_key_pair_name}"

  vpc_security_group_ids = [
    "${coalescelist(var.infra_public_security_group_ids, aws_security_group.deployment.*.id)}",
    "${coalescelist(var.internal_security_group_ids, aws_security_group.node.*.id)}"
  ]

  iam_instance_profile = ""

  user_data = "${data.template_file.deployment_init.rendered}"

  tags = "${merge(var.tags, map(
    "Name", "${var.platform_name}-deployment",
    "Role", "deployment-node"
    ))}"
}
