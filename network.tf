# for ebs pv provisioning, node instances must residence in all subnets.

locals {
  node_subnet_ids_count   = "${var.compute_node_count < length(var.private_subnet_ids) ? var.compute_node_count : length(var.private_subnet_ids)}"
  node_scaling_subnet_ids = "${slice(var.private_subnet_ids, 0, local.node_subnet_ids_count)}"

  infra_subnet_ids_count   = "${var.infra_node_count < length(var.private_subnet_ids) ? var.infra_node_count : length(var.private_subnet_ids)}"
  infra_scaling_subnet_ids = "${slice(var.private_subnet_ids, 0, local.infra_subnet_ids_count)}"
}

output subnets {
  value = "${local.node_scaling_subnet_ids}"
}
