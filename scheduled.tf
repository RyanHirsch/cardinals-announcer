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

data "archive_file" "announcer" {
  type        = "zip"
  output_path = "${path.module}/build/announcer.zip"
  source_dir = "${path.module}/lambda"
}

module "lambda_scheduled" {
  source              = "github.com/terraform-community-modules/tf_aws_lambda_scheduled"
  lambda_name         = "cardinal_game_announcer"
  runtime             = "nodejs6.10"
  lambda_zipfile      = "${path.module}/build/announcer.zip"
  source_code_hash    = "${data.archive_file.announcer.output_base64sha256}"
  handler             = "announce.handler"
  schedule_expression = "rate(1 day)"
  iam_policy_document = "${data.aws_iam_policy_document.announcer.json}"
}
