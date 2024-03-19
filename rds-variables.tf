variable "rds_identifier" {
    type = string
    default = "My-rds"
}
variable "rds_storage" {
    type = number
    default = 10
}
variable "rds_storage_type" {
    type = string
    default = "gp2"
}
variable "db_engine" {
    type = string
    default = "mysql"
}
variable "db_engine_version" {
    type =string
    default = "8.0.35"  
}
variable "rds_instance_type" {
    type = string
    default = "db.t2.micro"
}
variable "db_user" {
    type = string
}
variable "db_user_password" {
    type = string
}