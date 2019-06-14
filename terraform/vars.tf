variable "aws_region" {
  type    = string
  default = ""
}

variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}
variable "subnet_id" {
  type    = string
  default = ""
}
variable "packer_ami" {
  type    = string
  default = ""
}
variable "key_name" {
  type    = string
  default = ""
}
variable "instance_type" {
  type    = string
  default = ""
}

variable "cidr" {
  type    = string
  default = ""
}
variable "public_subnets" {
  type    = list(string)
  default = []
}
variable "private_subnets" {
  type    = list(string)
  default = []
}
variable "azs" {
  type    = list(string)
  default = []
}
variable "ami_owner" {
  type    = string
  default = "self"
}
