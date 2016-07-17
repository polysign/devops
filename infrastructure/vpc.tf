resource "aws_vpc" "default-vpc" {
  tags {
    Name = "${var.config.name}/Default"
  }

  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "default-public-subnet" {
  tags {
    Name = "${var.config.name}/PublicSubnet"
  }

  vpc_id = "${aws_vpc.default-vpc.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "${var.config.region}${var.config.availability-zone}"
  map_public_ip_on_launch = true
  depends_on = ["aws_internet_gateway.default-public-internet-gateway"]
}

resource "aws_internet_gateway" "default-public-internet-gateway" {
  tags {
    Name = "${var.config.name}/PublicInternetGateway"
  }

  vpc_id = "${aws_vpc.default-vpc.id}"
}

resource "aws_route_table" "default-public-route-table" {
  tags {
    Name = "${var.config.name}/PublicRouteTable"
  }

  vpc_id = "${aws_vpc.default-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default-public-internet-gateway.id}"
  }
}

resource "aws_route_table_association" "default-public-route-table-association" {
  subnet_id = "${aws_subnet.default-public-subnet.id}"
  route_table_id = "${aws_route_table.default-public-route-table.id}"
}

resource "aws_subnet" "default-private-subnet" {
  tags {
    Name = "${var.config.name}/PrivateSubnet"
  }

  vpc_id = "${aws_vpc.default-vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.config.region}${var.config.availability-zone}"
}
