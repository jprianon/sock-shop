output "vpc_id" {
  value = aws_vpc.vpc.id 
}

output "sg_pub_id" {
  value = aws_security_group.allow_ssh_pub.id
}

output "sg_priv_id" {
  value = aws_security_group.allow_ssh_priv.id
}

output "private_subnets_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnets_ids" {
  value = aws_subnet.public_subnets.*.id
}

#output "db_subnet_group_ids" {
#  value = aws_db_subnet_group.my_private_subnet_group.*.id
#}
