# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region  = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "part-2-vpc"
  cidr = "10.10.0.0/16"

  # Specify at least one of public_subnets
  azs           = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.10.101.0/24", "10.10.102.0/24"]
}

//the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda_execution" {
  name               = "iam_for_lambda_execute"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda_execution.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

//CloudWatch Log Group for the Lambda Function
resource "aws_cloudwatch_log_group" "py_lambda" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "py_lambda.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "py_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda_execution.arn
  handler       = "py_lambda.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.8"

    depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.py_lambda,
  ]

  environment {
    variables = {
      greeting = "Hello Udacity!"
    }
  }
}