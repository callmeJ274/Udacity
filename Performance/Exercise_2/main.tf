terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
 
# TODO: Designate a cloud provider, region, and credentials
# Set up aws connection  in local
# 1. run 'aws configure'
# 2. Fill: AWS Access Key ID: <>
#          AWS Secret Access Key: <>
#          Default region name : us-east-1
# So we can use shared_credentials_files with the directory as bellow (MacOS)
provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  region = var.region
}


data "archive_file" "archive" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = "greet_lambda.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "greet_lambda" {
  filename      = "greet_lambda.zip"
  function_name = "greet_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "greet_lambda.lambda_handler"

  source_code_hash = data.archive_file.archive.output_base64sha256

  runtime = "python3.7"

  depends_on = [aws_iam_role_policy_attachment.lambda_logs]

  environment {
    variables = {
      greeting = "Hi!"
    }
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}