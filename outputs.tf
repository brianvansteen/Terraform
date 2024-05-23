output "public_ip" {
  description = "Instance public IP"
  value       = aws_instance.web_server.public_ip
}

output "public_subnets" {
  description = "Instance public DNS"
  value       = aws_instance.web_server.public_dns
}

