variable "aws_instance" {
    type = string
    description = "The size of the instance."
    sensitive = true
    validation {
    condition = can(regex("^t", var.aws_instance))
    error_message = "The instance must be a t3 size."
    }
}

# resource "aws_s3_bucket" "bucket" {
#     bucket = "1341u2341451435rakljsdf"
#     depends_on = [ aws_instance.web_server ]
# }

# resource "aws_instance" "web_server" {
#   ami                    = "ami-04ff98ccbfa41c9ad"
#   instance_type          = var.aws_instance
#   tags = {
#     Name    = "AWS-Server"
#   }
# }

# output "aws_s3_bucket" {
#   value = aws_s3_bucket.bucket
#   description = "S3 bucket"
# }
