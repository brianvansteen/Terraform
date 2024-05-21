variable "myvar" {
  type    = string
  default = "Hello Terraform"
}

variable "mymap" {
  type = map(string)
  default = {
    mykey = "my value"
  }
}

variable "mylist" {
  type    = list(any)
  default = [43, 9, 14, 3]
}