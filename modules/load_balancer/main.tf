############# Application Load Balancer #############

resource "aws_lb" "main" {
  name               = "ALB-${terraform.workspace}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets
  tags               = { Name = "ALB-${terraform.workspace}" }
}

############# Target Group #############

resource "aws_lb_target_group" "tg" {
  name     = "TG-${terraform.workspace}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path     = "/"
    interval = 30
  }

  tags = { Name = "TG-${terraform.workspace}" }
}

resource "aws_lb_target_group_attachment" "ec2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instance_id
  port             = 80
}

############# Listener #############

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
