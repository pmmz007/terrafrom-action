// security group for Loadbalancer
resource "aws_security_group" "alb_nsg" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.myvpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_lb" "mylb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_nsg.id]
  subnets            = [for subnet in aws_subnet.public-subnets : subnet.id]
  #subnet_mapping {
  #  subnet_id = aws_subnet.public-subnets[count.index].id
  #}
  enable_deletion_protection = false


  tags = {
    Environment = "production"
  }
}



resource "aws_lb_target_group_attachment" "webgroup-attach" {
  count            = 2
  target_group_arn = aws_lb_target_group.webserver-group.arn
  target_id        = aws_instance.webservers[count.index].id
  port             = 80
}



resource "aws_lb_target_group" "webserver-group" {
  name        = "webserver-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.myvpc.id
  target_type = "instance"
}

resource "aws_lb_listener" "my-lb-lsnrctl" {
  load_balancer_arn = aws_lb.mylb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver-group.arn
  }
}