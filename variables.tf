variable "region" {
  type    = "string"
  default = "us-east-2"
}

variable "profile" {
  description = "What AWS profile to use for deployment"
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
