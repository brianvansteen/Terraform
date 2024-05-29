# output "public_ip" {
#   description = "Instance public IP"
#   # value       = aws_instance.web_server.public_ip
#   # value       = aws_instance.web_server[*].public_ip # splat for lists
#   value = values(aws_instance.web_server)[*].public_ip # splat for maps
#   # sensitive = true
# }

# output "public_dns" {
#   description = "Instance public DNS"
#   # value       = aws_instance.web_server[*].public_dns # splat for lists
#   value = values(aws_instance.web_server)[*].public_dns # splat for maps
# }

# ssh ec2-user@$(terraform output -raw public_ip) -i terraform

# output "aws_s3_bucket" {
#   value = aws_s3_bucket.bucket.bucket_domain_name
#   description = "S3 bucket"
# }

output "east_public_ip" {
  value = aws_instance.my_east_server.public_ip
}
output "west_public_ip" {
  value = aws_instance.my_west_server.public_ip
}