resource "aws_iam_role" "voucherfactory_lambda_iam" {
  name = "voucherfactory_lambda_iam"
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

resource "aws_iam_role_policy_attachment" "voucherfactory_lambda_DynamoDBFullAccess"{
  role = aws_iam_role.voucherfactory_lambda_iam.name
  policy_arn = aws_iam_policy.lambda_apigateway_policy.arn
}

resource "aws_lambda_permission" "voucherfactory_apigateway_test"{
  statement_id  = "AllowAPIGatewayInvoke-test"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.voucherfactory_lambda.function_name

  source_arn    = "${aws_api_gateway_rest_api.voucherfactory_api.execution_arn}/*/POST/VoucherFactory"
}
resource "aws_lambda_permission" "voucherfactory_apigateway_default"{
  statement_id  = "AllowAPIGatewayInvoke-default"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.voucherfactory_lambda.function_name

  source_arn    = "${aws_api_gateway_rest_api.voucherfactory_api.execution_arn}/default/POST/VoucherFactory"
}

resource "aws_lambda_function" "voucherfactory_lambda" {
  filename      = "../build/voucherfactory.zip"
  function_name = "VoucherFactory"
  role          = aws_iam_role.voucherfactory_lambda_iam.arn
  handler       = "voucherfactory.lambda_handler"
  source_code_hash = filebase64sha256("../build/voucherfactory.zip")
  runtime       = "python3.8"
  

#  environment {
#    variables = {
#    }
#  }
}

