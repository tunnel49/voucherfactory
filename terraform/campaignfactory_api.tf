resource "aws_api_gateway_method" "campaignfactory_post"{
  http_method = "POST"
  authorization = "NONE"

  rest_api_id = aws_api_gateway_rest_api.voucherfactory_api.id
  resource_id = aws_api_gateway_resource.campaignfactory.id
}


resource "aws_api_gateway_integration" "campaignfactory_post_integration"{
  type = "AWS"
  uri = aws_lambda_function.campaignfactory_lambda.invoke_arn
  integration_http_method = "POST"
  
  rest_api_id = aws_api_gateway_rest_api.voucherfactory_api.id
  resource_id = aws_api_gateway_resource.campaignfactory.id
  http_method = aws_api_gateway_method.campaignfactory_post.http_method
}

resource "aws_api_gateway_method_response" "campaignfactory_post_response_200" {
  status_code = 200

  rest_api_id = aws_api_gateway_rest_api.voucherfactory_api.id
  resource_id = aws_api_gateway_resource.campaignfactory.id
  http_method = aws_api_gateway_method.campaignfactory_post.http_method
}
resource "aws_api_gateway_integration_response" "campaignfactory_post_integration_response_200" {
  response_templates = {
    "application/json" = ""
  }
 
  rest_api_id = aws_api_gateway_rest_api.voucherfactory_api.id
  resource_id = aws_api_gateway_resource.campaignfactory.id
  http_method = aws_api_gateway_method.campaignfactory_post.http_method
  status_code = aws_api_gateway_method_response.campaignfactory_post_response_200.status_code
}


resource "aws_api_gateway_method_response" "campaignfactory_post_response_400" {
  status_code = 400

  rest_api_id = aws_api_gateway_rest_api.voucherfactory_api.id
  resource_id = aws_api_gateway_resource.campaignfactory.id
  http_method = aws_api_gateway_method.campaignfactory_post.http_method
}
resource "aws_api_gateway_integration_response" "campaignfactory_post_integration_response_400" {
  response_templates = {
    "application/json" = <<EOF
#set ($inputRoot = $input.path('$'))
{ 
    'statusCode': 400,
    'body': $inputRoot.errorMessage
}
EOF
  }
  selection_pattern = "400:.*"
 
  rest_api_id = aws_api_gateway_rest_api.voucherfactory_api.id
  resource_id = aws_api_gateway_resource.campaignfactory.id
  http_method = aws_api_gateway_method.campaignfactory_post.http_method
  status_code = aws_api_gateway_method_response.campaignfactory_post_response_400.status_code
  depends_on = [
    aws_api_gateway_integration.campaignfactory_post_integration
  ]
}

