# creating security group for rds
resource "aws_security_group" "rds-sg" {
    name = "rds-sg"
    description = "security group for relational database"
    vpc_id = aws_vpc.My-vpc.id
    tags = {
      name = "rds-sg"
    }
}
# inbound rules for red-sg
resource "aws_vpc_security_group_ingress_rule" "rds_ingress" {
    security_group_id = aws_security_group.rds-sg.id
    cidr_ipv4 = aws_vpc.My-vpc.cidr_block
    from_port = var.ingress_port_3306
    to_port = var.ingress_port_3306
    ip_protocol = var.ingress_protocol
}
# outbound rules for rds-sg
resource "aws_vpc_security_group_egress_rule" "rds_egress" {
    security_group_id = aws_security_group.rds-sg.id
    cidr_ipv4 = aws_vpc.My-vpc.cidr_block
    from_port = var.egress_port
    to_port = var.egress_port
    ip_protocol = var.egress_protocol
}
# creating subnet group for using multi-cluster
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "my-rds-subnet-group"
  subnet_ids = [aws_subnet.pri_east_1a.id, aws_subnet.pri_east_1b.id]
}

# creating rds
resource "aws_db_instance" "my_rds_db" {
    identifier = var.rds_identifier
    allocated_storage = var.rds_storage
    storage_type = var.rds_storage_type
    engine = var.db_engine
    engine_version = var.db_engine_version
    instance_class = var.rds_instance_type
    username = var.db_user
    password = var.db_user_password
    skip_final_snapshot   = true
    publicly_accessible = false
    multi_az = true
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids = [ aws_security_group.rds-sg.id ]
}