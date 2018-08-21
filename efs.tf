resource "aws_efs_file_system" "persistent_volumes" {
  count          = "${var.deploy_efs ? 1 : 0}"
  creation_token = "${var.platform_name}"

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-efs"))}"
}

data "aws_availability_zones" "az" {}

resource "aws_efs_mount_target" "persistent_volumes" {
  count           = "${var.deploy_efs ? length(data.aws_availability_zones.az.names) : 0}"
  file_system_id  = "${aws_efs_file_system.persistent_volumes.id}"
  subnet_id       = "${element(var.private_subnet_ids, count.index)}"
  security_groups = ["${coalescelist(var.cluster_internal_security_group_ids, aws_security_group.node.*.id)}"]
}
