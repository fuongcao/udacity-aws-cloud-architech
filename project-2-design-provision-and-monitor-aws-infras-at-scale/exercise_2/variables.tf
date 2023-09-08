# TODO: Define the variable for aws_region
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

variable "lambda_function_name" {
  description = "Lambda Function Name"
  default     = "py_lambda"
}

