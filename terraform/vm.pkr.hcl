
variable "profile" {
  type    = string
  default = ""
}

data "amazon-ami" "autogenerated_1" {
  access_key = "${var.profile}"
  filters = {
    name                = "ubuntu-minimal/images/hvm-ssd/ubuntu-hirsute-21.04-amd64-minimal-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "us-east-1"
}

source "amazon-ebs" "autogenerated_1" {
  access_key            = "${var.profile}"
  ami_name              = "my-vm-${formatdate("MM-DD-YYYY", timestamp())}"
  force_delete_snapshot = "true"
  force_deregister      = "true"
  instance_type         = "t2.medium"
  region                = "us-east-1"
  source_ami            = "${data.amazon-ami.autogenerated_1.id}"
  ssh_username          = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.autogenerated_1"]

  provisioner "file" {
    destination = "/tmp/"
    source      = "./script.sh"
  }

  provisioner "file" {
    destination = "/tmp/"
    source      = "./.env"
  }

  provisioner "shell-local" {
    command = "tar --exclude-vcs --exclude='../terraform' --exclude='../.github/' --exclude='../docs' -zcvf  ./mqtt.ter.tgz  ../"
  }
  provisioner "file" {
    destination = "/tmp/"
    source      = "./mqtt.ter.tgz"
  }
  provisioner "shell" {
    inline = ["bash /tmp/script.sh yes"]
  }
}
