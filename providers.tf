# Provider Configuration

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  version = "~> 1.0"
  region = "${var.aws_region}"
}


