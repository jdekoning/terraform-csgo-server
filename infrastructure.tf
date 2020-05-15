# Infrastructure related to csgo-server
## Startup Script
data "template_file" "csgo-server-launcher-conf" {
  template = file("templates/csgo-server-launcher.conf")

  vars = {
    screen-name            = var.screen-name
    user                   = var.user
    port                   = var.port
    gslt                   = var.gslt
    dir-steamcmd           = var.dir-steamcmd
    steam-login            = var.steam-login
    steam-password         = var.steam-password
    steam-runscript        = var.steam-runscript
    dir-root               = var.dir-root
    dir-game               = var.dir-game
    dir-logs               = var.dir-logs
    daemon-game            = var.daemon-game
    update-log             = var.update-log
    update-email           = var.update-email
    update-retry           = var.update-retry
    api-authorization-key  = var.api-authorization-key
    workshop-collection-id = var.workshop-collection-id
    workshop-start-map     = var.workshop-start-map
    maxplayers             = var.maxplayers
    tickrate               = var.tickrate
    extraparams            = var.extraparams
    param-start            = var.param-start
    param-update           = var.param-update
    public-ip              = aws_eip.csgo-server.public_ip
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "csgo-vpc" {
  cidr_block = var.cidr-block
}

resource "aws_internet_gateway" "csgo-gw" {
  vpc_id = aws_vpc.csgo-vpc.id

  tags = {
    Name = "CSGO for the win"
  }
}

data "aws_route_table" "csgo-route-table" {
  vpc_id = aws_vpc.csgo-vpc.id
}

resource "aws_route" "csgo-internet-route" {
  route_table_id            = data.aws_route_table.csgo-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.csgo-gw.id
}

resource "aws_subnet" "csgo-subnet" {
  vpc_id = aws_vpc.csgo-vpc.id
  cidr_block = var.cidr-block
}

resource "aws_security_group" "csgo-security-group" {
  name        = "csgo-security-group"
  description = "Allos CSGO and ssh from me"
  vpc_id      = aws_vpc.csgo-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "CSGO TCP"
    from_port   = 27015
    to_port     = 27015
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "CSGO UDP 51840"
    from_port   = 51840
    to_port     = 51840
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "CSGO UDP rest"
    from_port   = 27005
    to_port     = 27020
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from me"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh-access-ip}/32"]
  }
}

resource "aws_key_pair" "master-key" {
  key_name   = "master-key"
  public_key = file(var.public-key-path)
}

## CSGO Server
resource "aws_instance" "csgo-server" {
  depends_on = [aws_internet_gateway.csgo-gw]
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.csgo-instance-machine-type

  vpc_security_group_ids = [aws_security_group.csgo-security-group.id]
  subnet_id = aws_subnet.csgo-subnet.id

  root_block_device {
    volume_size = 40
  }
  key_name = aws_key_pair.master-key.key_name

  tags = {
    Name = "CSGO for the win"
  }
}

resource "null_resource" "configure-csgo-server" {

  triggers = {
    cluster_instance = aws_instance.csgo-server.id
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = aws_eip.csgo-server.public_ip
    agent = true
    timeout = "3m"
  }

  provisioner "file" {
    destination = "/tmp/csgo-server-launcher.conf"
    content = data.template_file.csgo-server-launcher-conf.rendered
  }

  provisioner "file" {
    destination = "/tmp/startup.sh"
    content = file("files/startup.sh")
  }

  provisioner "file" {
    destination = "/tmp/install.sh"
    content = file("files/install.sh")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/startup.sh"
    ]
  }
}

resource "aws_eip" "csgo-server" {
  instance = aws_instance.csgo-server.id
  vpc      = true
}

output "csgo_server_ip" {
  value = aws_eip.csgo-server.public_ip
}
