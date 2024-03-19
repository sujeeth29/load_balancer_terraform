# public variables
variable "name_sg_public" {
  type    = string
  default = "public-sg"
}
variable "description_public" {
  type    = string
  default = "public-sg for public instances"
}
variable "all_cidr_ipv4" {
  type    = string
  default = "0.0.0.0/0"
}
variable "ingress_port_80" {
  type    = number
  default = 80
}
variable "ingress_port_22" {
  type    = number
  default = 22
}
variable "ingress_port_3306" {
  type    = number
  default = 3306
}
variable "ingress_protocol" {
  type    = string
  default = "tcp"
}
variable "egress_port" {
  type    = number
  default = 0
}
variable "egress_protocol" {
  type    = string
  default = "-1"
}
variable "public_instance_type" {
  type    = string
  default = "t2.micro"
}
variable "instance_name_public_AZ-1a" {
  type    = string
  default = "public-1a"
}
variable "instance_name_public_AZ-1b" {
  type    = string
  default = "public-1b"
}
variable "script_public-1" {
  type    = string
  default = "nginx-1.sh"
}
variable "script_public-2" {
  type    = string
  default = "nginx-2.sh"
}
variable "ami-id" {
  type    = string
  default = "ami-07d9b9ddc6cd8dd30"
}
variable "public_key_name" {
  type    = string
  default = "develop"
}
# private variables
variable "private_instance_type" {
  type    = string
  default = "t2.micro"
}
variable "name_sg_private" {
  type    = string
  default = "private-sg"
}
variable "description_private" {
  type    = string
  default = "private-sg for public instances"
}
variable "private_key_name" {
  type    = string
  default = "testing"
}
variable "instance_name_private_AZ-1a" {
  type    = string
  default = "private-1a"
}
variable "instance_name_private_AZ-1b" {
  type    = string
  default = "private-1b"
}
variable "tg_name" {
  type    = string
  default = "My-tg"
}
variable "tg_type" {
  type    = string
  default = "instance"
}
variable "lb_name" {
  type    = string
  default = "My-lb"
}
variable "lb_type" {
  type    = string
  default = "application"
}
variable "lb_protocol" {
  type    = string
  default = "HTTP"

}
