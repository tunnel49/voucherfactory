resource "aws_iam_role" "deletecampaign_lambda_iam" {
  name = "deletecampaign_lambda_iam"
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

resource "aws_iam_role_policy_attachment" "deletecampaign_lambda_DynamoDBFullAccess"{
  role = aws_iam_role.deletecampaign_lambda_iam.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_lambda_function" "deletecampaign_lambda" {
  filename      = "../build/deletecampaign.zip"
  function_name = "DeleteCampaign"
  role          = aws_iam_role.deletecampaign_lambda_iam.arn
  handler       = "deletecampaign.lambda_handler"
  source_code_hash = filebase64sha256("../build/deletecampaign.zip")
  runtime       = "python3.8"

#  environment {
#    variables = {
#    }
#  }
}

