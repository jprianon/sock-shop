variable "namespace" {
  type = string
}

variable "vpc" {
  type    = string
}

variable "public_subnets_cidrs" {
  type    = list(string)
  default = ["10.0.128.0/20", "10.0.144.0/20"]
}

variable "private_subnets_cidrs" {
  type    = list(string)
}

variable "available_zones" {
  type    = list(string)
}

variable "single_nat_gateway" {
  type    = bool
}

variable "enable_nat_gateway" {
  type    = bool
}

variable "subnet_public_name" {
  type    = string
}

variable "subnet_private_name" {
  type    = string
}

variable "rtb_public_name" {
  type    = string
}

variable "vpc_name" {
  type    = string
}

variable "public_subnets_igw_name" {
  type    = string
}

variable "nat_gw_name" {
  type    = string
}

#variable "private_db_subnet_group" {
#  type    = string
#}

variable "elastic_ip_name" {
  type    = string
}