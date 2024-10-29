resource "aws_lb" "jp-elb" {
  name            = var.lb_name
  internal        = var.internal
  security_groups = [var.security_group_id]
  subnets         = var.subnet_ids
}

resource "aws_lb_listener" "jp-listener" {
  load_balancer_arn = aws_lb.jp-elb.arn
  protocol         = var.protocol
  port             = var.port

  default_action {
    target_group_arn = aws_lb_target_group.jp-target.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "jp-target" {
  name     = var.target_group_name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
}

resource "aws_lb_target_group_attachment" "wordpress_vms_association" {
  count            = length(var.private_subnets_cidrs)
  target_group_arn = element(aws_lb_target_group.jp-target[*].arn, count.index)
  target_id        = element(var.wordpress_id, count.index)

  port = 80
}

resource "aws_autoscaling_attachment" "lb_wordpress-autoscaling_association" {
  count                  = length(var.private_subnets_cidrs)
  autoscaling_group_name = var.wordpress_autoscaling_id
  lb_target_group_arn    = element(aws_lb_target_group.jp-target[*].arn, count.index)
}