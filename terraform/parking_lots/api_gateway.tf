# Create the REST API
resource "aws_api_gateway_rest_api" "parking_lots_api" {
  name        = "ParkingLotsAPI"
  description = "API for querying parking lots"
}

# Create the resource for /parking_lots/{development}
resource "aws_api_gateway_resource" "parking_lots" {
  rest_api_id = aws_api_gateway_rest_api.parking_lots_api.id
  parent_id   = aws_api_gateway_rest_api.parking_lots_api.root_resource_id
  path_part   = "parking_lots"
}

resource "aws_api_gateway_resource" "parking_lot_by_id" {
  rest_api_id = aws_api_gateway_rest_api.parking_lots_api.id
  parent_id   = aws_api_gateway_resource.parking_lots.id
  path_part   = "{development}" # Define path parameter {development}
}

# Create GET method for /parking_lots/{development}
resource "aws_api_gateway_method" "get_parking_lot" {
  rest_api_id   = aws_api_gateway_rest_api.parking_lots_api.id
  resource_id   = aws_api_gateway_resource.parking_lot_by_id.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integrate the GET method with the Lambda function
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.parking_lots_api.id
  resource_id             = aws_api_gateway_resource.parking_lot_by_id.id
  http_method             = aws_api_gateway_method.get_parking_lot.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_parking_lots_lambda.invoke_arn
}

# Grant API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_parking_lots_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  #source_arn    = "${aws_api_gateway_rest_api.parking_lots_api.execution_arn}/*/*"
  source_arn = "arn:aws:execute-api:ap-southeast-1:${data.aws_caller_identity.current_caller_for_get_parking_lot_lambda.account_id}:${aws_api_gateway_rest_api.parking_lots_api.id}/*/GET/parking_lots/*"
}

# Deploy the API
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.parking_lots_api.id
  stage_name  = "prod"

  depends_on = [aws_api_gateway_integration.lambda_integration]
}


