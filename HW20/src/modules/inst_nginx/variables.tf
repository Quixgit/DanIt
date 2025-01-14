variable "vpc_id" {
  type        = string
}

variable "list_of_open_ports" {
  type        = list(number)
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}