# creating public security group
resource "aws_security_group" "public-sg" {
  name        = var.name_sg_public
  description = var.description_public
  vpc_id      = aws_vpc.My-vpc.id
  tags = {
    name = var.name_sg_public
  }
}
#allowing port 80 to public-sg
resource "aws_vpc_security_group_ingress_rule" "allow-port-80_public" {
  security_group_id = aws_security_group.public-sg.id
  cidr_ipv4         = var.all_cidr_ipv4
  from_port         = var.ingress_port_80
  to_port           = var.ingress_port_80
  ip_protocol       = var.ingress_protocol
}
#allowing port 22 to public-sg
resource "aws_vpc_security_group_ingress_rule" "allow-port-22_public" {
  security_group_id = aws_security_group.public-sg.id
  cidr_ipv4         = var.all_cidr_ipv4
  from_port         = var.ingress_port_22
  to_port           = var.ingress_port_22
  ip_protocol       = var.ingress_protocol
}
#allowing outbound rules to public-sg
resource "aws_vpc_security_group_egress_rule" "egress_rule" {
  security_group_id = aws_security_group.public-sg.id
  cidr_ipv4         = var.all_cidr_ipv4
  from_port         = var.egress_port
  to_port           = var.egress_port
  ip_protocol       = var.egress_protocol
}
# creating public instances in both AZ
resource "aws_instance" "pub-ec2-1a" {
  ami             = var.ami-id
  key_name        = var.public_key_name
  instance_type   = var.public_instance_type
  subnet_id       = aws_subnet.pub_east_1a.id
  security_groups = [aws_security_group.public-sg.id]
  user_data       = file(var.script_public-1)
  tags = {
    Name = var.instance_name_public_AZ-1a
  }

}
resource "aws_instance" "pub-ec2-1b" {
  ami             = var.ami-id
  key_name        = var.public_key_name
  instance_type   = var.public_instance_type
  subnet_id       = aws_subnet.pub_east_1b.id
  security_groups = [aws_security_group.public-sg.id]
  user_data       = file(var.script_public-2)
  tags = {
    Name = var.instance_name_public_AZ-1b
  }

}
# creating Private security group
resource "aws_security_group" "private-sg" {
  name        = var.name_sg_private
  description = var.description_private
  vpc_id      = aws_vpc.My-vpc.id
  tags = {
    name = var.name_sg_private
  }
}
# allow port 80 to private-sg
resource "aws_vpc_security_group_ingress_rule" "allow_port_80_private" {
  security_group_id = aws_security_group.private-sg.id
  cidr_ipv4         = aws_vpc.My-vpc.cidr_block
  from_port         = var.ingress_port_80
  to_port           = var.ingress_port_80
  ip_protocol       = var.ingress_protocol
}
# allow port 22 to private-sg
resource "aws_vpc_security_group_ingress_rule" "allow_port_22_private" {
  security_group_id = aws_security_group.private-sg.id
  cidr_ipv4         = aws_vpc.My-vpc.cidr_block
  from_port         = var.ingress_port_22
  to_port           = var.ingress_port_22
  ip_protocol       = var.ingress_protocol
}
# allow port 3306 to private-sg
resource "aws_vpc_security_group_ingress_rule" "allow_port_3306_private" {
  security_group_id = aws_security_group.private-sg.id
  cidr_ipv4         = aws_vpc.My-vpc.cidr_block
  from_port         = var.ingress_port_3306
  to_port           = var.ingress_port_3306
  ip_protocol       = var.ingress_protocol
}
# allow all traffic for outbound rule to private-sg
resource "aws_vpc_security_group_egress_rule" "allow_port_all_private" {
    security_group_id = aws_security_group.private-sg.id
    cidr_ipv4         = var.all_cidr_ipv4
    from_port         = var.egress_port
    to_port           = var.egress_port
    ip_protocol       = var.egress_protocol
}

# creating private instances in both AZ
resource "aws_instance" "pri-ec2-1a" {
  ami             = var.ami-id
  key_name        = var.private_key_name
  instance_type   = var.private_instance_type
  subnet_id       = aws_subnet.pri_east_1a.id
  security_groups = [aws_security_group.private-sg.id]
  tags = {
    Name = var.instance_name_private_AZ-1a
  }
}
resource "aws_instance" "pri-ec2-1b" {
  ami             = var.ami-id
  key_name        = var.private_key_name
  instance_type   = var.private_instance_type
  subnet_id       = aws_subnet.pri_east_1b.id
  security_groups = [aws_security_group.private-sg.id]
  tags = {
    Name = var.instance_name_private_AZ-1b
  }
}

# creating target group for load balancer
resource "aws_lb_target_group" "My-tg" {
  name        = var.tg_name
  port        = var.ingress_port_80
  protocol    = var.lb_protocol
  vpc_id      = aws_vpc.My-vpc.id
  target_type = var.tg_type
}

# Setting target instances for target group
resource "aws_lb_target_group_attachment" "My-tg-attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.My-tg.arn
  target_id        = element([aws_instance.pub-ec2-1a.id, aws_instance.pub-ec2-1b.id], count.index)
  port             = var.ingress_port_80
}

# creating application load balancer
resource "aws_lb" "My_alb" {
  name               = var.lb_name
  internal           = false # Set to true if you want an internal ALB
  load_balancer_type = var.lb_type
  subnets            = [aws_subnet.pub_east_1a.id, aws_subnet.pub_east_1b.id] # Specify your subnets
  security_groups    = [aws_security_group.public-sg.id]                      # Specify your security group(s)
}

resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.My_alb.arn
  port              = var.ingress_port_80
  protocol          = var.lb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.My-tg.arn
  }
}
