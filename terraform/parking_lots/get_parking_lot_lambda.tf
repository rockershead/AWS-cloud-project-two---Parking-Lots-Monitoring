resource "aws_lambda_function" "get_parking_lots_lambda" {
    filename            = "${abspath(path.module)}/../../lambdas/get_parking_lots/${var.get_lambda_zip_filename}"
    source_code_hash    = filebase64sha256("${abspath(path.module)}/../../lambdas/get_parking_lots/${var.get_lambda_zip_filename}")
    role                = aws_iam_role.get_parking_lots_lambda_role.arn
    function_name       = var.get_lambda_function_name
    handler             = "get_parking_lots.lambda_handler"   ##change sample_project_lambda according to the python file name
    runtime             = "python3.10"
    timeout             = 30

    description         = "Lambda to get parking lots based onn location from dynamodb"

    vpc_config {
        security_group_ids  = [aws_security_group.security_group.id]
        subnet_ids          = tolist(aws_subnet.private_subnets[*].id)
    }

    environment {
        variables = {
            TABLE_NAME               = var.parking_table_name
            
            
        }
    }


    

    depends_on = [
        aws_iam_role.get_parking_lots_lambda_role,
        aws_vpc.main,
        aws_subnet.private_subnets,
        aws_security_group.security_group
    ]
}

resource "aws_iam_role" "get_parking_lots_lambda_role" {
    name                = "${var.get_lambda_function_name}_role"
    description         = "Lambda execution role for ${var.get_lambda_function_name}"    
    assume_role_policy  = data.aws_iam_policy_document.assume_get_parking_lots_lambda_role.json

    inline_policy {
        name = "get_parking_lots_lambda_role_policy"
        policy = data.aws_iam_policy_document.get_parking_lots_lambda_role_permissions.json
    }
}

data "aws_iam_policy_document" "assume_get_parking_lots_lambda_role" {
    statement {
        effect = "Allow"

        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

data "aws_iam_policy_document" "get_parking_lots_lambda_role_permissions" {

    ##dynamodb

    statement {
        actions     = [
            "dynamodb:Query"
            
        ]
        resources   = ["arn:aws:dynamodb:ap-southeast-1:${data.aws_caller_identity.current_caller_for_get_parking_lot_lambda.account_id}:table/${var.parking_table_name}"]
        effect      = "Allow"
    }

    

    

   # Permissions required for lambda to execute in VPC
    statement {
        actions     = [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
        ]
        resources   = ["*"]
        effect      = "Allow"
    }

    #Cloudwatch Logs permission required for Lambda
    statement {
        actions     = [
            "logs:CreateLogGroup"
        ]
        resources   = [
            "arn:aws:logs:ap-southeast-1:${data.aws_caller_identity.current_caller_for_get_parking_lot_lambda.account_id}:*"
        ]
        effect      = "Allow"
    }

    statement {
        actions     = [
            "logs:CreateLogStream"
        ]
        resources   = [
            "arn:aws:logs:ap-southeast-1:${data.aws_caller_identity.current_caller_for_get_parking_lot_lambda.account_id}:log-group:/aws/lambda/${var.get_lambda_function_name}:*"
        ]
        effect      = "Allow"
    }
    statement {
        actions     = [
            "logs:PutLogEvents"
        ]
        resources   = [
            "arn:aws:logs:ap-southeast-1:${data.aws_caller_identity.current_caller_for_get_parking_lot_lambda.account_id}:log-group:/aws/lambda/${var.get_lambda_function_name}:log-stream:*"
        ]
        effect      = "Allow"
    }

    
}
