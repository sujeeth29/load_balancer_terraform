output "aws_lb" {
  value = aws_lb.My_alb.dns_name
}
output "aws_db_instance" {
  value = aws_db_instance.my_rds_db.endpoint
}
