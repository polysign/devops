resource "aws_instance" "server-management" {
  tags {
    Name = "${var.config.name}/Management/${count.index + 1}"
  }

  ami = "${var.config.default-ami}"
  instance_type = "${var.config.management-instance-type}"
  vpc_security_group_ids = ["${aws_security_group.default-security-group.id}"]
  associate_public_ip_address = true
  key_name = "${aws_key_pair.devop.key_name}"
  subnet_id = "${aws_subnet.default-public-subnet.id}"

  connection {
    type = "ssh"
    user = "${var.config.instance-user-name}"
    private_key = "${file("${path.module}/../certs/devops")}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install -y language-pack-UTF-8",
      "mkdir -p /usr/local/bin/",
      "mkdir -p /home/${var.config.instance-user-name}/containers"
    ]
  }

  provisioner "file" {
    source = "${path.module}/../containers/drone"
    destination = "/home/${var.config.instance-user-name}/containers"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i '' 's/{{drone-driver}}/${var.config.drone-driver}/g' containers/drone/dronerc",
      "sed -i '' 's/{{drone-remote-config}}/${var.config.drone-remote-config}/g' containers/drone/dronerc"
    ]
  }

  provisioner "file" {
    source = "${path.module}/../containers/rancher"
    destination = "/home/${var.config.instance-user-name}/containers"
  }

  provisioner "file" {
    source = "${path.module}/../docker-compose.yml"
    destination = "/home/${var.config.instance-user-name}/docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "wget -qO- https://get.docker.com/ | sh",
      "sudo usermod -aG docker ubuntu",
      "curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > docker-compose",
      "sudo cp docker-compose /usr/local/bin",
      "sudo chmod +x /usr/local/bin/docker-compose"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "docker-compose build --no-cache",
      "docker-compose up -d"
    ]
  }
}

resource "aws_instance" "server-docker" {
  tags {
    Name = "${var.config.name}/Docker/${count.index + 1}"
  }

  count = "${var.config.docker-server-count}"
  ami = "${var.config.default-ami}"
  instance_type = "${var.config.docker-instance-type}"
  vpc_security_group_ids = ["${aws_security_group.default-security-group.id}"]
  key_name = "${aws_key_pair.devop.key_name}"
  subnet_id = "${aws_subnet.default-public-subnet.id}"

  connection {
    type = "ssh"
    user = "${var.config.instance-user-name}"
    private_key = "${file("${path.module}/../certs/devops")}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "wget -qO- https://get.docker.com/ | sh"
    ]
  }
}
