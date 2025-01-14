variable "vpc_id" {
  type        = string
}

variable "list_of_open_ports" {
  type        = list(number)
}

variable "login_name" {
  type        = string
}