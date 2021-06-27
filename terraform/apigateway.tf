resource "aws_api_gateway_rest_api" "voucherfactory_api"{
  name = "VoucherFactory"
}

resource "aws_api_gateway_resource" "campaignfactory"{
  path_part = "CampaignFactory"

  rest_api_id = aws_api_gateway_rest_api.voucherfactory_api.id
  parent_id = aws_api_gateway_rest_api.voucherfactory_api.root_resource_id
}
resource "aws_api_gateway_resource" "voucherfactory"{
  path_part = "VoucherFactory"

  rest_api_id = aws_api_gateway_rest_api.voucherfactory_api.id
  parent_id = aws_api_gateway_rest_api.voucherfactory_api.root_resource_id
}
resource "aws_api_gateway_resource" "voucheroverseer"{
  path_part = "VoucherOverseer"

  rest_api_id = aws_api_gateway_rest_api.voucherfactory_api.id
  parent_id = aws_api_gateway_rest_api.voucherfactory_api.root_resource_id
}

resource "aws_api_gateway_deployment" "campaignfactory_deployment"{
  stage_name = "default"

  rest_api_id = aws_api_gateway_rest_api.voucherfactory_api.id

  depends_on = [
    aws_api_gateway_integration.campaignfactory_post_integration,
    aws_api_gateway_integration.voucherfactory_post_integration,
    aws_api_gateway_integration.voucheroverseer_post_integration,
  ]
} 

resource "aws_iam_policy" "lambda_apigateway_policy" {
  name = "lambda-apigateway-policy"
  policy = jsonencode({
    "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "Stmt1428341300017",
          "Action": [
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:UpdateItem"
          ],
          "Effect": "Allow",
          "Resource": "*"
        },
        {
          "Sid": "",
          "Resource": "*",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Effect": "Allow"
        }
      ]
  })
}

