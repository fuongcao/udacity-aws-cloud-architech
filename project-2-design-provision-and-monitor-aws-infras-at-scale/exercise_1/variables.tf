variable "aws_access_key" {
    type        = string
}
variable "aws_secret_key" {
    type        = string
}
variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}
variable "aws_vpc" {
  description = "AWS VPC"
  default        = "vpc-03fe25a3ca122db96"
}

variable "aws_subnet_id" {
  description = "AWS Subnet"
  default        = "subnet-053add8b2a614973f"
}
