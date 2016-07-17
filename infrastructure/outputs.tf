output "Rancher Url" {
  value = "http://rancher.${var.config.domain}:8001"
}

output "Drone Url" {
  value = "http://drone.${var.config.domain}:8002"
}

output "Rancher Server SSH" {
  value = "ssh -i certs/devops ubuntu@${aws_instance.server-management.public_dns}"
}

output "Management Load Balancer" {
  value = "${aws_elb.management-load-balancer.dns_name}"
}

output "Docker Load Balancer" {
  value = "${aws_elb.docker-load-balancer.dns_name}"
}

output "Docker Server IPs" {
  value = "${join(", ", aws_instance.server-docker.*.public_ip)}"
}
