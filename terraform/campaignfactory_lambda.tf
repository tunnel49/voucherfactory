resource "aws_iam_role" "campaignfactory_lambda_iam" {
  name = "campaignfactory_lambda_iam"
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

resource "aws_lambda_function" "campaignfactory_lambda" {
  filename      = "campaignfactory_payload.zip"
  function_name = "CampaignFactory"
  role          = aws_iam_role.campaignfactory_lambda_iam.arn
  handler       = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("campaignfactory_payload.zip")
  runtime       = "python3.8"

  environment {
    variables = {
    }
  }
}

