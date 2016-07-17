provider "aws" {
  access_key = "${var.config.access_key}"
  secret_key = "${var.config.secret_key}"
  region = "${var.config.region}"
}
