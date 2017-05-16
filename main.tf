# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-f2b39792
#
# Your subnet ID is:
#
#     subnet-f4056fac
#
# Your security group ID is:
#
#     sg-578da130
#
# Your Identity is:
#
#     HashiDays-2017-tf-owl
#
terraform {
  backend "atlas" {
    name = "jpribula/training"
  }
}

module "example" {
  source  = "./example-module"
  command = "echo Goodbye World"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  count                  = "2"
  ami                    = "ami-f2b39792"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-f4056fac"
  vpc_security_group_ids = ["sg-578da130"]

  tags {
    "Identity" = "HashiDays-2017-tf-owl"
    "Name"     = "ops-ooc-web-${count.index+1}"
    "Spec"     = "prod"
  }
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

#output "command" {
#  value = "${module.example.command}"
#}

