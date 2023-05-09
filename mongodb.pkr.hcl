packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "cactus-kenny-packer-challenge"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["862686223907"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "packer-challenge"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  
    provisioner "shell" {

        inline = [
        "sudo apt-get install gnupg",
        "sleep 30",
        "curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
            sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
            --dearmor",
        "echo deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/6.0 multiverse | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list",
        "sudo apt-get update",
        "sudo apt-get install -y mongodb-org",
        "sudo systemctl enable mongod",
        "sudo systemctl start mongod",
        "sudo systemctl status mongod"
        ]
    }
}

