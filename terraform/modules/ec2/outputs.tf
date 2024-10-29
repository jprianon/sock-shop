#ip de l'instance publique
output "public_ip" {
  value = aws_instance.ec2_public[0].public_ip
}
#ip de l'instance privée
output "private_ip" {
  value = aws_instance.ec2_private[0].public_ip
}

output "wordpress_ids" {
  value = aws_instance.ec2_public.*.id
}

output "webservers-autoscaling_ids" {
  value = aws_autoscaling_group.wordpress-autoscaling.id
}
