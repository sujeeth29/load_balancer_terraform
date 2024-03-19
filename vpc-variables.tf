variable "access_key" {
  type    = string
}
variable "secret_key" {
  type    = string
}
variable "region" {
  type    = string
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "vpc_name" {
  type    = string
  default = "My-vpc"
}
variable "az_1" {
  type    = string
  default = "us-east-1a"
}
variable "az_2" {
  type    = string
  default = "us-east-1b"
}
variable "pub_subnet_az_1_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "pub_subnet_name_az_1" {
  type    = string
  default = "public_east_1a"

}
variable "pub_subnet_az_2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}
variable "pub_subnet_name_az_2" {
  type    = string
  default = "public_east_1b"

}
variable "pri_subnet_az_1_cidr" {
  type    = string
  default = "10.0.3.0/24"
}
variable "pri_subnet_name_az_1" {
  type    = string
  default = "private_east_1a"
}
variable "pri_subnet_az_2_cidr" {
  type    = string
  default = "10.0.4.0/24"
}
variable "pri_subnet_name_az_2" {
  type    = string
  default = "private_east_1b"
}
variable "igw_name" {
  type    = string
  default = "my_igw"

}