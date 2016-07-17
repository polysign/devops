output "Rancher Url" {
  value = "http://rancher.${var.config.domain}:8001"
}

output "Drone Url" {
  value = "http://drone.${var.config.domain}:8002"
}

output "Rancher Server SSH" {
  value = "ssh -i certs/devops ubuntu@${aws_instance.server-management.public_dns}"
}

output "Docker Server IPs" {
  value = "${join(", ", aws_instance.server-docker.*.public_ip)}"
}

output "Domain Name Servers for ${var.config.domain}" {
  value = "${join(", ", aws_route53_zone.main-zone.name_servers)}"
}
