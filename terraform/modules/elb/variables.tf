variable "lb_name" {
  description = "Name of the load balancer"
}

variable "internal" {
  description = "Is the load balancer internal"
  default     = false
}

variable "security_group_id" {
  description = "The security group id to attach to the load balancer"
}

variable "subnet_ids" {
  description = "A list of subnet ids to attach to the load balancer"
  type        = list(string)
}

variable "private_subnets_cidrs" {
  type = list(string)
}

variable "protocol" {
  description = "The protocol for the listener"
  default     = "HTTP"
}

variable "port" {
  description = "The port for the listener"
  default     = 80
}

variable "target_group_name" {
  description = "The name for the target group"
  default     = "wordpress-tg"
}

variable "vpc_id" {
  type = string
  description = "The vpc id for the target group"
}

variable "health_check_path" {
  description = "The health check path"
  default     = "/health"
}

variable "health_check_timeout" {
  description = "The health check timeout"
  default     = 5
}

variable "health_check_interval" {
  description = "The health check interval"
  default     = 30
}

variable "healthy_threshold" {
  description = "The healthy threshold"
  default     = 2
}

variable "unhealthy_threshold" {
  description = "The unhealthy threshold"
  default     = 2
}

variable "wordpress_id" {
  type = list(string)
}


variable "wordpress_autoscaling_id" {
  type = string
}