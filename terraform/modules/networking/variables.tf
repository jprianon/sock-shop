variable "namespace" {
  type = string
}

variable "vpc" {
  type    = string
}

variable "public_subnets_cidrs" {
  type    = list(string)
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
