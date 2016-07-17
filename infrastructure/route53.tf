resource "aws_route53_zone" "main-zone" {
  name = "${var.config.domain}"
  vpc_id = "${aws_vpc.default-vpc.id}"
}

resource "aws_route53_record" "dns-rancher" {
   zone_id = "${aws_route53_zone.main-zone.zone_id}"
   name = "rancher.${var.config.domain}"
   type = "CNAME"
   ttl = "300"
   records = ["${aws_elb.management-load-balancer.dns_name}"]
}

resource "aws_route53_record" "dns-drone" {
   zone_id = "${aws_route53_zone.main-zone.zone_id}"
   name = "drone.${var.config.domain}"
   type = "CNAME"
   ttl = "300"
   records = ["${aws_elb.management-load-balancer.dns_name}"]
}
