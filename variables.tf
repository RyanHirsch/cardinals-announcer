variable "region" {
  type    = "string"
  default = "us-east-1"
}

variable "webhook_url" {
  type = "string"
}

variable "lambda_name" {
  type    = "string"
  default = "cardinal_game_announcer"
}

variable "enabled" {
  default = true
}
