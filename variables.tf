variable "instance_count" {
  description = "Number of EC2 instances to create"
  default     = 2
}
variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t3.small"
}

variable "key_name" {
  description = "AWS EC2 SSH key name"
}
variable "nms_host" {
  description = "FQDN of the NMS instance"
}

variable "owner_name" {
  description = "Owner name"
}

variable "owner_email" {
  description = "Owner email address"
}
variable "region" {
  description = "AWS region"
  default     = "us-west-1"
}

variable "tailscale_auth_key" {
  description = "Tailscale Device Auth Key"
}

locals {
  owner_name_safe = lower(replace(var.owner_name, " ", "-"))
}
