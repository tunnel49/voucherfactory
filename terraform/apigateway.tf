resource "aws_api_gateway_rest_api" "voucherfactory_api"{
  name = "StartExecutionAPI"
}

resource "aws_api_gateway_resource" "campaignfactory"{
  path_part = "CampaignFactory"

  rest_api_id = aws_api_gateway_rest_api.voucherfactory_api.id
  parent_id = aws_api_gateway_rest_api.voucherfactory_api.root_resource_id
}
