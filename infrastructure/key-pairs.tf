resource "aws_key_pair" "devop" {
  key_name = "${var.config.namespace}-key-pair"
  public_key = "${file("${path.module}/../certs/devops.pub")}"
}
