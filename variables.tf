variable "cidr_block" {
  type        = string
  description = "VPC network address space"
  default     = "192.168.0.0/16"
}

variable "environment" {
  type    = string
  default = "development"

}

variable "access_key" {
  type        = string
  description = "your access key in here"
  default     = "AKIAZHIYF32MX6WJMK6H"
}

variable "secret_key" {
  type        = string
  description = "your secret key in here"
  default     = "howYyGcEnrAPSHvuaZLgfTxE0QacVKfYXiI/DHWb"
}

variable "myigw" {
  type    = string
  default = "Demo-IGW"
}

variable "subnet_count" {
  type        = number
  description = "subnet count"
  default     = 3
}

variable "cidr_blocks" {
  type        = list(string)
  description = "subnet addresses"
  default     = ["192.168.100.0/24", "192.168.200.0/24", "192.168.201.0/24"]
}

variable "route_tbl_count" {
  type        = number
  description = "numbers of route table"
  default     = 2

}

variable "gateway_id" {
  type    = string
  default = "local"

}

variable "company" {
  type    = string
  default = "MITT"

}

variable "version_name" {
  type    = string
  default = "V1"

}

locals {
  common_tags = {
    company = var.company
    version = var.version_name
    project = "${var.company}-${var.version_name}"
  }
}

variable "subnet_name" {
  type    = string
  default = "mitt-public-subnet"

}

variable "pr-rtbs" {
  type    = string
  default = "mitt-private-rtbl"

}

variable "alb_name" {
  type        = string
  description = "Name of application loadbalancer"
  default     = "mitt-app-lb"
}