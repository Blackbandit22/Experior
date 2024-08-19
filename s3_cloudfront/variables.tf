variable "s3_bucket_name" {
  description = "The name of the S3 bucket to be created."
  type        = string
}

variable "environment" {
  description = "The environment in which to deploy (e.g., dev, prod)."
  type        = string
}
variable "alb_dns_name" {
  description = "The DNS name of the load balancer"
}