output "bastion_id" {
  description = "ID of the bastion host"
  value       = aws_instance.bastion.id
}

output "public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_eip.bastion.public_ip
}

output "security_group_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion.id
}
