data "archive_file" "announcer" {
  type        = "zip"
  output_path = "${path.module}/build/announcer.zip"
  source_dir  = "${path.module}/lambda"
}

data "aws_iam_policy_document" "announcer" {
  statement {
    sid = "1"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name = "${var.lambda_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda" {
  name   = "${var.lambda_name}"
  role   = "${aws_iam_role.lambda.name}"
  policy = "${data.aws_iam_policy_document.announcer.json}"
}

resource "aws_lambda_function" "lambda" {
  runtime          = "nodejs6.10"
  function_name    = "${var.lambda_name}"
  role             = "${aws_iam_role.lambda.arn}"
  filename         = "${path.module}/build/announcer.zip"
  source_code_hash = "${data.archive_file.announcer.output_base64sha256}"
  handler          = "announce.handler"
  count            = "${var.enabled}"
  timeout          = "30"

  environment {
    variables = {
      URL = "${var.webhook_url}"
    }
  }
}

resource "aws_lambda_permission" "cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.lambda.arn}"
  count         = "${var.enabled}"
}

resource "aws_cloudwatch_event_rule" "lambda" {
  name                = "${var.lambda_name}"
  schedule_expression = "rate(1 day)"
  count               = "${var.enabled}"
}

resource "aws_cloudwatch_event_target" "lambda" {
  target_id = "${var.lambda_name}"
  rule      = "${aws_cloudwatch_event_rule.lambda.name}"
  arn       = "${aws_lambda_function.lambda.arn}"
  count     = "${var.enabled}"
}
