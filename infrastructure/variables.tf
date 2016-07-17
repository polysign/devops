variable "config" {
  type = "map"

  default = {
    region = "eu-west-1"
    availability-zone = "a"
    default-ami = "ami-ed82e39e"
    instance-user-name = "ubuntu"
    management-instance-type = "t2.small"
    docker-instance-type = "t2.small"
    docker-server-count = 3

    domain = "example.com"
    namespace = "demo"
    name = "Demo"
  }
}
