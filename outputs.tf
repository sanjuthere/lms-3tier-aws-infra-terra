output "frontend_public_ip" {
  value = aws_instance.frontend.public_ip
}

output "internal_lb_dns" {
  value = aws_lb.internal.dns_name
}
