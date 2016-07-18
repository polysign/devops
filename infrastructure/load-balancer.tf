resource "aws_elb" "management-load-balancer" {
  tags {
    Name = "${var.config.name}/Management/LoadBalancer"
  }

  name = "${var.config.name}-Management-ELB"
  subnets = ["${aws_subnet.default-public-subnet.id}"]

  listener {
    instance_port = 8001
    instance_protocol = "http"
    lb_port = 8001
    lb_protocol = "http"
  }

  listener {
    instance_port = 8002
    instance_protocol = "http"
    lb_port = 8002
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 10
    timeout = 5
    target = "TCP:8001"
    interval = 10
  }

  instances = ["${aws_instance.server-management.*.id}"]
  cross_zone_load_balancing = false
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
}

resource "aws_elb" "docker-load-balancer" {
  tags {
    Name = "${var.config.name}/Docker/LoadBalancer"
  }

  name = "${var.config.name}-Docker-LoadBalancer"
  subnets = ["${aws_subnet.default-public-subnet.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 10
    timeout = 5
    target = "TCP:8001"
    interval = 10
  }

  instances = ["${aws_instance.server-docker.*.id}"]
  cross_zone_load_balancing = false
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
}
