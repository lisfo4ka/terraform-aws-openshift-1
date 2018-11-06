data "aws_elb_service_account" "main" {}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "elb_logs" {
  bucket        = "${var.platform_name}-elb-logs-${data.aws_caller_identity.current.account_id}"
  acl           = "private"
  force_destroy = true

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.platform_name}-elb-logs-${data.aws_caller_identity.current.account_id}/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-elb-logs-${data.aws_caller_identity.current.account_id}", "user:tag", "EDP-shared-${var.platform_name}"))}"
}

resource "aws_s3_bucket" "openshift_registry_storage" {
  bucket = "${var.platform_name}-${local.openshift_registry_s3_bucket_name}-${data.aws_caller_identity.current.account_id}"
  acl           = "private"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:ListBucketMultipartUploads"
            ],
            "Principal": {
                "AWS": [
                    "${var.create_iam_profiles ? join("",aws_iam_role.slave_node.*.arn) : join("",data.aws_iam_instance_profile.existing_slave_node.*.role_arn)}"
                ]
            },
            "Resource": [
                "arn:aws:s3:::${var.platform_name}-${local.openshift_registry_s3_bucket_name}-${data.aws_caller_identity.current.account_id}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListMultipartUploadParts",
                "s3:AbortMultipartUpload"
            ],
            "Principal": {
                "AWS": [
                    "${var.create_iam_profiles ? join("",aws_iam_role.slave_node.*.arn) : join("",data.aws_iam_instance_profile.existing_slave_node.*.role_arn)}"
                ]
            },
            "Resource": [
                "arn:aws:s3:::${var.platform_name}-${local.openshift_registry_s3_bucket_name}-${data.aws_caller_identity.current.account_id}/*"
            ]
        }
    ]
}
POLICY

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-${local.openshift_registry_s3_bucket_name}-${data.aws_caller_identity.current.account_id}", "user:tag", "EDP-shared-${var.platform_name}"))}"
}
