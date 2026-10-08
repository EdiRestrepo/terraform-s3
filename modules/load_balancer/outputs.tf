output "alb_dns_name" {
  description = "DNS publico del Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN del Application Load Balancer"
  value       = aws_lb.main.arn
}

output "target_group_arn" {
  description = "ARN del Target Group"
  value       = aws_lb_target_group.tg.arn
}
