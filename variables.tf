variable "aws_region" {
  type = string
  default = "us-east-2"
}

variable "access_key" {
  type        = string
  default     = ""
}

variable "secret_key" {
  type        = string
  default     = ""
}

variable "cloudmapper_access_key" {
  type        = string
  default     = ""
}

variable "cloudmapper_secret_key" {
  type        = string
  default     = ""
}

variable "aws_account_name" {
  type        = string
  default     = ""
}

variable "aws_account_id" {
  type        = string
  default     = ""
}

data "template_file" "cloudmapper_script" {
  template = "${file("cloudmapper_script.tpl")}"
  vars = {
    cloudmapper_access_key = var.cloudmapper_access_key
    cloudmapper_secret_key = var.cloudmapper_secret_key
    aws_account_name = var.aws_account_name
    aws_account_id = var.aws_account_id
    aws_region = var.aws_region
  }
}

variable "public_key_name" {
  type        = string
  default     = "ssh_public_key"
}

variable "private_key_name" {
  type        = string
  default     = "ssh_private_key"
}

variable "key_path" {
  type        = string
  default     = "/var/lib/jenkins/.ssh/"
}
