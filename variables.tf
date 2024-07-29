variable "namespace" {
  description = "L'espace de noms de projet à utiliser pour la dénomination unique des ressources"
  #default     = "Datascientest"
  type        = string
}

variable "key_name" {
  description = "SSH key"
  default     = "Datascientest-jp"
  type        = string
}

variable "region" {
  description = "AWS région"
  default     = "eu-west-3"
  type        = string
}

variable "vpc" {
  type        = string
  #default     = "10.0.0.0/16"
  description = "main vpc"
}

variable "public_subnets_cidrs" {
  type    = list(string)
  #default = ["10.0.128.0/20", "10.0.144.0/20"]
}

variable "private_subnets_cidrs" {
  type    = list(string)
  #default = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "instance_type" {
  default = "t3.micro"
  type = string
}

variable "enable_nat_gateway" {
  default = true
}

variable "single_nat_gateway" {
  default = true
}

variable "nat_gw_name" {
  default = true
}

#variable "private_db_subnet_group" {
#  default = true
#}

variable "vpc_name" {
  default = true
}

variable "subnet_private_name" {
  default = true
}

variable "elastic_ip_name" {
  default = true
}

variable "rtb_public_name" {
  default = true
}

variable "subnet_public_name" {
  default = true
}

variable "available_zones" {
  type    = list(string)
}


