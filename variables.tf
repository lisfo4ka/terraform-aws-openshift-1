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
  type = "list"
}

variable "operator_cidrs" {
  type    = "list"
  default = []
}

variable "public_access_cidrs" {
  type    = "list"
  default = []
}

variable "ami_id" {
  type = "string"
}

variable "user_name" {
  type = "string"
}

variable "rhn_username" {}
variable "rhn_password" {}
variable "rh_subscription_pool_id" {}

variable "master_count" {}

variable "master_asg_suspended_processes" {
  type    = "list"
  default = []
}

variable "master_spot_price" {}

variable "master_instance_type" {}

variable "master_public_lb_port" {
  default = "8443"
}

variable "compute_node_count" {}

variable "compute_asg_suspended_processes" {
  type    = "list"
  default = []
}

variable "compute_node_spot_price" {}

variable "compute_node_instance_type" {}

variable "infra_node_count" {}

variable "infra_asg_suspended_processes" {
  type    = "list"
  default = []
}

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

variable "need_deployment_node" {
  description = "Boolean variable which defines whether a deployment node will be deployed or not"
  default     = false
}

variable "master_public_security_group_ids" {
  type    = "list"
  default = []
}

variable "infra_public_security_group_ids" {
  type    = "list"
  default = []
}

variable "cluster_internal_security_group_ids" {
  type    = "list"
  default = []
}

variable "create_iam_profiles" {
  description = "Flag which define wheather IAM Profiles for cluster nodes should be created or not"
  default     = false
}

variable "slave_node_iam_profile_name" {
  description = "IAM Profile which will be assumed by slave nodes"
  default     = ""
}

variable "master_node_iam_profile_name" {
  description = "IAM Profile which will be assumed by master nodes"
  default     = ""
}

variable "deployment_node_iam_profile_name" {
  description = "IAM Profile which will be assumed by deployment nodes"
  default     = ""
}

variable "deploy_efs" {
  description = "Boolean variable that defines wheather EFS storage will be deployed or not"
}
