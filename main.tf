locals {
  project_name = "Cloud DR"
}

module "aws_server" {
  source       = ".//aws_server"
  aws_instance = "t3.nano"
}

# output "private_ip" {
#   description = "Instance public IP"
#   value       = module.aws_server.private_ip
#   # sensitive = true
# }

# output "private_dns" {
#   description = "Instance private DNS"
#   value       = module.aws_server.private_dns
# }
