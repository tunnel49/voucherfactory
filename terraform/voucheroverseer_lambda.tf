resource "aws_iam_role" "voucheroverseer_lambda_iam" {
  name = "voucheroverseer_lambda_iam"
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

resource "aws_iam_role_policy_attachment" "voucheroverseer_lambda_DynamoDBFullAccess"{
  role = aws_iam_role.voucheroverseer_lambda_iam.name
  policy_arn = aws_iam_policy.lambda_apigateway_policy.arn
}

resource "aws_lambda_permission" "voucheroverseer_apigateway_test"{
  statement_id  = "AllowAPIGatewayInvoke-test"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.voucheroverseer_lambda.function_name

  source_arn    = "${aws_api_gateway_rest_api.voucherfactory_api.execution_arn}/*/POST/VoucherOverseer"
}
resource "aws_lambda_permission" "voucheroverseer_apigateway_default"{
  statement_id  = "AllowAPIGatewayInvoke-default"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.voucheroverseer_lambda.function_name

  source_arn    = "${aws_api_gateway_rest_api.voucherfactory_api.execution_arn}/default/POST/VoucherOverseer"
}



resource "aws_lambda_function" "voucheroverseer_lambda" {
  filename      = "../build/voucheroverseer.zip"
  function_name = "VoucherOverseer"
  role          = aws_iam_role.voucheroverseer_lambda_iam.arn
  handler       = "voucheroverseer.lambda_handler"
  source_code_hash = filebase64sha256("../build/voucheroverseer.zip")
  runtime       = "python3.8"
  

#  environment {
#    variables = {
#    }
#  }
}

