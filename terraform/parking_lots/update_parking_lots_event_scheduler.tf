resource "aws_scheduler_schedule" "update_parking_lots_schedule" {
    name        = "${var.update_lambda_function_name}_Schedule"

    description = "Schedule to invoke ${var.update_lambda_function_name} following this cron expression: ${var.cron_expression_for_update_parking_lots_schedule}"

    flexible_time_window {
        mode = "OFF"
    }

    schedule_expression             = "cron(${var.cron_expression_for_update_parking_lots_schedule})"
    schedule_expression_timezone    = "Asia/Singapore"

    target {
        arn         = aws_lambda_function.update_parking_lots_lambda.arn
        role_arn    = aws_iam_role.update_parking_lots_scheduler_role.arn
    }
}

resource "aws_lambda_permission" "allow_eventbridge_scheduler_to_invoke_update_parking_lots_lambda" {
    statement_id    = "AllowInvocationFromEventBridgeScheduler"
    action          = "lambda:InvokeFunction"
    function_name   = aws_lambda_function.update_parking_lots_lambda.function_name
    principal       = "scheduler.amazonaws.com"
    source_arn      = aws_scheduler_schedule.update_parking_lots_schedule.arn
}

resource "aws_iam_role" "update_parking_lots_scheduler_role" {
    name                = "${var.update_lambda_function_name}_Schedule_role"
    assume_role_policy  = data.aws_iam_policy_document.assume_update_parking_lots_lambda_scheduler_role.json

    inline_policy {
        name    = "update_parking_lots_scheduler_role_policy"
        policy  = data.aws_iam_policy_document.update_parking_lots_schedule_role_permissions.json
    }

    description         = "Scheduler execution role to invoke ${var.update_lambda_function_name}"
}

data "aws_iam_policy_document" "assume_update_parking_lots_lambda_scheduler_role" {
    statement {
        effect = "Allow"

        principals {
            type        = "Service"
            identifiers = ["scheduler.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

data "aws_iam_policy_document" "update_parking_lots_schedule_role_permissions" {
    statement {
        actions = [
            "lambda:InvokeFunction"
        ]
        resources = [
            aws_lambda_function.update_parking_lots_lambda.arn
        ]
        effect = "Allow"
    }
}
