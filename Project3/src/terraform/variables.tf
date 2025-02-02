variable "ssh_key_name" {
  type        = string
  default     = "my_ssh_key"
  description = "SSH EC2"
}

variable "instance_type_master" {
  type        = string
  default     = "t3.micro"
  description = "Jenkins master"
}

variable "instance_type_worker" {
  type        = string
  default     = "t3.micro"
  description = "Jenkins worker"
}