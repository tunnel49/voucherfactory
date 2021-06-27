resource "aws_iam_role" "campaignfactory_lambda_iam" {
  name = "campaignfactory_lambda_iam"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "apigateway.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid":""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "campaignfactory_lambda_DynamoDBFullAccess"{
  role = aws_iam_role.campaignfactory_lambda_iam.name
  policy_arn = aws_iam_policy.lambda_apigateway_policy.arn
}

resource "aws_lambda_permission" "campaignfactory_apigateway_test"{
  statement_id  = "AllowAPIGatewayInvoke-test"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.campaignfactory_lambda.function_name

  source_arn    = "${aws_api_gateway_rest_api.voucherfactory_api.execution_arn}/*/POST/CampaignFactory"
}
resource "aws_lambda_permission" "campaignfactory_apigateway_default"{
  statement_id  = "AllowAPIGatewayInvoke-default"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.campaignfactory_lambda.function_name

  source_arn    = "${aws_api_gateway_rest_api.voucherfactory_api.execution_arn}/default/POST/CampaignFactory"
}



resource "aws_lambda_function" "campaignfactory_lambda" {
  filename      = "../build/campaignfactory.zip"
  function_name = "CampaignFactory"
  role          = aws_iam_role.campaignfactory_lambda_iam.arn
  handler       = "campaignfactory.lambda_handler"
  source_code_hash = filebase64sha256("../build/campaignfactory.zip")
  runtime       = "python3.8"
  

#  environment {
#    variables = {
#    }
#  }
}

