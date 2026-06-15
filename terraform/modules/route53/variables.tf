variable "domain_name" {
  description = "Root domain name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "create_private_zone" {
  description = "Create a private hosted zone"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID for private hosted zone association"
  type        = string
  default     = ""
}
