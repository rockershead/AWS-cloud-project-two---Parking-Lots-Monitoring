resource "aws_lambda_function" "update_parking_lots_lambda" {
    filename            = "${abspath(path.module)}/../../lambdas/update_parking_lots/${var.update_lambda_zip_filename}"
    source_code_hash    = filebase64sha256("${abspath(path.module)}/../../lambdas/update_parking_lots/${var.update_lambda_zip_filename}")
    role                = aws_iam_role.update_parking_lots_lambda_role.arn
    function_name       = var.update_lambda_function_name
    handler             = "update_parking_lots.lambda_handler"   ##change sample_project_lambda according to the python file name
    runtime             = "python3.10"
    timeout             = 30

    description         = "Lambda to update parking lots in the city"

    vpc_config {
        security_group_ids  = [aws_security_group.security_group.id]
        subnet_ids          = tolist(aws_subnet.private_subnets[*].id)
    }

    environment {
        variables = {
            TABLE_NAME               = var.parking_table_name
            URL                      = var.API_URL
            
        }
    }


    

    depends_on = [
        aws_iam_role.update_parking_lots_lambda_role,
        aws_vpc.main,
        aws_subnet.private_subnets,
        aws_security_group.security_group
    ]
}

resource "aws_iam_role" "update_parking_lots_lambda_role" {
    name                = "${var.update_lambda_function_name}_role"
    description         = "Lambda execution role for ${var.update_lambda_function_name}"    
    assume_role_policy  = data.aws_iam_policy_document.assume_update_parking_lots_lambda_role.json

    inline_policy {
        name = "update_parking_lots_lambda_role_policy"
        policy = data.aws_iam_policy_document.update_parking_lots_lambda_role_permissions.json
    }
}

data "aws_iam_policy_document" "assume_update_parking_lots_lambda_role" {
    statement {
        effect = "Allow"

        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

data "aws_iam_policy_document" "update_parking_lots_lambda_role_permissions" {

    ##dynamodb

    statement {
        actions     = [
            "dynamodb:PutItem",
            
        ]
        resources   = ["arn:aws:dynamodb:ap-southeast-1:${data.aws_caller_identity.current_caller_for_update_parking_lot_lambda.account_id}:table/${var.parking_table_name}"]
        effect      = "Allow"
    }

    ##parameter store

    statement {
        actions     = [
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:GetParametersByPath",
            "ssm:DescribeParameters"
            
        ]
        resources   = ["arn:aws:ssm:ap-southeast-1:${data.aws_caller_identity.current_caller_for_update_parking_lot_lambda.account_id}:parameter/LTA_ACCOUNT_KEY"]
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
            "arn:aws:logs:ap-southeast-1:${data.aws_caller_identity.current_caller_for_update_parking_lot_lambda.account_id}:*"
        ]
        effect      = "Allow"
    }

    statement {
        actions     = [
            "logs:CreateLogStream"
        ]
        resources   = [
            "arn:aws:logs:ap-southeast-1:${data.aws_caller_identity.current_caller_for_update_parking_lot_lambda.account_id}:log-group:/aws/lambda/${var.update_lambda_function_name}:*"
        ]
        effect      = "Allow"
    }
    statement {
        actions     = [
            "logs:PutLogEvents"
        ]
        resources   = [
            "arn:aws:logs:ap-southeast-1:${data.aws_caller_identity.current_caller_for_update_parking_lot_lambda.account_id}:log-group:/aws/lambda/${var.update_lambda_function_name}:log-stream:*"
        ]
        effect      = "Allow"
    }

    
}
