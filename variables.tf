variable "region" {
  type = "string"
}

variable "platform_cidr" {
  type = "string"
}

variable "platform_name" {}

variable "platform_vpc_id" {}

variable "platform_internal_subdomain" {}

variable "platform_external_subdomain" {
  default = ""
}

variable "private_subnet_ids" {
  type = "list"
}

variable "public_subnet_ids" {
  default = []
  type    = "list"
}

variable "operator_cidrs" {
  type = "list"
}

variable "public_access_cidrs" {
  type = "list"
}

variable "ami_id" {
  type = "string"
}

variable "user_name" {
  type = "string"
}

variable "upstream" {}

variable "rhn_username" {}
variable "rhn_password" {}
variable "rh_subscription_pool_id" {}

variable "master_count" {}

variable "master_spot_price" {}

variable "master_instance_type" {}

variable "compute_node_count" {}

variable "compute_node_spot_price" {}

variable "compute_node_instance_type" {}

variable "infra_node_count" {}

variable "infra_node_spot_price" {}

variable "infra_node_instance_type" {}

variable "ssh_key_pair_name" {}

variable "tags" {
  type = "map"
}

variable "openshift_major_version" {
  type = "string"
}

variable "internet_facing" {
  description = "Define if ELBs for master and infra nodes are internet-facing (exteral or internal)"
}

variable "gerrit_ssh_port" {
  description = "Gerrit SSH port. Update after EDP deploy"
  default     = "31000"
}

variable "deployer" {
  description = "Option to deploy deployer node"
  default     = false
}

variable "master_public_security_group_ids" {
  type = "list"
}

variable "infra_public_security_group_ids" {
  type = "list"
}

variable "internal_security_group_ids" {
  type = "list"
}