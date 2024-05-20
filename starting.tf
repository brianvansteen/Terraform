variable "myvar" {
    type = string
    default = "Hello Terraform"
}

variable "mymap" {
    type = may(string)
    default = "Hello Terraform"
}
