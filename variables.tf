# variables.tf

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
  type        = string
}


variable "environment" {
  description = "The environment (e.g., dev, prod)."
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "public_subnet_az1_cidr" {
  description = "List of private subnet IDs"
  type        = string
}
variable "public_subnet_az2_cidr" {
  description = "List of private subnet IDs"
  type        = string
}
variable "private_subnet_az1_cidr" {
  description = "List of private subnet IDs"
  type        = string
}
variable "private_subnet_az2_cidr" {
  description = "List of private subnet IDs"
  type        = string
}
variable "az1" {
  description = "List of private subnet IDs"
  type        = string
}
variable "az2" {
  description = "List of private subnet IDs"
  type        = string
}
variable "vpc_cidr" {
  description = "List of private subnet IDs"
  type        = string
}
variable "vpc_name" {
  description = "List of private subnet IDs"
  type        = string
}
