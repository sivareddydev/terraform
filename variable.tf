variable "AWS_ACCESS_KEY" {
  description = "Access key ID for the AWS user"
}

variable "AWS_SECRET_KEY" {
  description = "Secret access key ID to authenticate your requests"
}

variable "iam_policy_attachment" {
  description = "The policy document (via file) to apply to the bucket"
}

variable "acl_permission" {
  description = "access control list (ACL) options for you to grant and manage bucket-level permissions"
}

variable "storage_class" {
  description = "The storage classes for the S3 objects in a bucket"
}

variable "status" {
  description = "Status to Enable/Disable"
}

variable "max_age_seconds" {
  description = "Max age seconds for the cross origin resource sharing(CORS)"
}

variable "storage_class2" {
  description = "The storage classes for the S3 objects in a bucket"
}

variable "transition_days" {
  description = "number of days to transition objects to another Amazon S3 storage class"
}

variable "versioning_enabled" {
  description = "Versioning to recover objects from being deleted or overwritten by mistake"
}

variable "role_name" {
  description = "The role document (via file) to apply to the bucket"
}

variable "role_policy_name" {
  description = "The role policy document (via file) to apply to the bucket"
}

variable "source_replication_id"{
  description = "Cross-region replication is the automatic, asynchronous copying of objects across buckets in different AWS Regions"
}

variable "acl_logging" {
  description = "Logging enables you to track requests for access to your bucket"
}

variable "server_side_encryption_configuration" {
  description = "Objects created with server-side encryption using customer-provided KMS encryption keys"
}

variable "lifecycle_rule_id1" {
  description = "Name of the lifecycle rule"
}

variable "lifecycle_rule_storage_class1" {
  description = "The storage classes for the S3 objects in a bucket"
}

variable "source_bucket_name" {
  description = "list of buckets to create in specified region"
  type    = "list"
  default = ["cdbft001", "microservicesft001", "networkfacingft001", "mediationft001", "logsft001", "dsipdataauditft001" ]
}

variable "dest_bucket_name" {
  description = "list of buckets to create in specified region"
  type    = "list"
  default = ["cdbid001", "microservicesid001", "networkfacingid001", "mediationid001", "logsid001", "dsipdataauditid001"]
}
