variable "bucket_name" {
  description = "value of the bucket name to store terraform state"
  type = string

}

variable "dynamodb_table_name" {
  description = "value of the dynamodb table name to store terraform state"
  type = string

}

variable "aws_region" {
  description = "value of the aws region"
  type = string

}