resource "aws_iam_role" "replication" {
  name = "${var.role_name}"
  assume_role_policy = "${file("iam_roles.json")}"
}

resource "aws_iam_policy" "replication" {
  name = "${var.role_policy_name}"
  policy = "${file("iam_policy.json")}"
}

resource "aws_iam_policy_attachment" "replication" {
  name       = "${var.iam_policy_attachment}"
  roles      = ["${aws_iam_role.replication.name}"]
  policy_arn = "${aws_iam_policy.replication.arn}"
}

resource "aws_kms_key" "s3kmskey" {
  description = "This key is used to encrypt bucket objects"
}

resource "aws_s3_bucket" "replicabucket" {
  count  = "${length(var.dest_bucket_name)}"
  bucket = "${element(var.dest_bucket_name, count.index)}"
  acl    = "${var.acl_permission}"
  acl    = "${var.acl_logging}"
  region = "eu-west-1"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.s3kmskey.arn}"
        sse_algorithm     = "${var.server_side_encryption_configuration}"
      }
    }
  }

  versioning {
    enabled = "${var.versioning_enabled}"
  }

  logging {
    target_bucket = "${element(var.dest_bucket_name, count.index)}"
    target_prefix = "logs/"
  }

  tags = {
      "Name"  = "Ireland-Specific"
  }

  lifecycle_rule {
    id      = "${var.lifecycle_rule_id1}"
    enabled = "${var.versioning_enabled}"
    prefix  = "archive/"
    transition {
      days          = 0
      storage_class = "${var.lifecycle_rule_storage_class1}"
    }
   }

  lifecycle_rule {
    id      = "Data Retention Rule"
    enabled = true

  noncurrent_version_expiration {
      days = 30
    }
  expiration {
      days = 2190
    }
  }
  lifecycle_rule {
    id      = "Country Data Retention Rule"
    enabled = true
    prefix  = "country/"

  noncurrent_version_expiration {
      days = 30
    }
   }
  lifecycle_rule {
    id      = "LifeCycle Infrequent Rules"
    enabled = true

  transition {
      days          = 180
      storage_class = "STANDARD_IA"
    }


  noncurrent_version_transition {
      days          = 30
      storage_class = "${var.storage_class2}"
    }
}
  lifecycle_rule {
    id      = "LifeCycle Non Real-Time Rules"
    enabled = true

  transition {
      days          = "${var.transition_days}"
      storage_class = "${var.storage_class2}"
    }
}

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    max_age_seconds = "${var.max_age_seconds}"
  }

}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  count = 6
  bucket = "${element(aws_s3_bucket.replicabucket.*.id, count.index)}"
  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "s3bucketkmskey" {
  description = "This key is used to encrypt bucket objects"
}

resource "aws_s3_bucket" "bucket" {
  provider = "aws.central"
  count    = "${length(var.source_bucket_name)}"
  bucket   = "${element(var.source_bucket_name, count.index)}"
  acl      = "${var.acl_permission}"
  acl      = "${var.acl_logging}"
  region   = "eu-central-1"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.s3bucketkmskey.arn}"
        sse_algorithm     = "${var.server_side_encryption_configuration}"
      }
    }
  }


  versioning {
    enabled = "${var.versioning_enabled}"
  }


  logging {
    target_bucket = "${element(var.source_bucket_name, count.index)}"
    target_prefix = "logs/"
  }

  tags = {
      "Name"  = "Frankfurt-Specific"
    }

  lifecycle_rule {
    id      = "Archive Transition Rule"
    enabled = true
    prefix  = "archive/"

    transition {
      days          = 0
      storage_class = "GLACIER"
    }
   }

  lifecycle_rule {
    id      = "Data Retention Rule"
    enabled = true

  noncurrent_version_expiration {
      days = 30
    }


  expiration {
      days = 2190
    }
}
  lifecycle_rule {
    id      = "Country Data Retention Rule"
    enabled = true
    prefix  = "country/"

  noncurrent_version_expiration {
      days = 30
    }
}

  lifecycle_rule {
    id      = "LifeCycle Infrequent Rules"
    enabled = true

  transition {
      days          = 180
      storage_class = "STANDARD_IA"
    }


  noncurrent_version_transition {
      days          = 30
      storage_class = "${var.storage_class2}"
    }
}
  lifecycle_rule {
    id      = "LifeCycle Non Real-Time Rules"
    enabled = true

  transition {
      days          = "${var.transition_days}"
      storage_class = "${var.storage_class2}"
    }
}
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    max_age_seconds = "${var.max_age_seconds}"
  }

  replication_configuration {
    role = "${aws_iam_role.replication.arn}"

    rules {
      id     = "${var.source_replication_id}"
      status = "${var.status}"

      destination {
        bucket        = "arn:aws:s3:::${element(var.dest_bucket_name, count.index)}"
        storage_class = "${var.storage_class}"
      }
    }
}
}


resource "aws_s3_bucket_public_access_block" "public_access_block2" {
  provider = "aws.central"
  count = 6
  bucket = "${element(aws_s3_bucket.bucket.*.id, count.index)}"
  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}


