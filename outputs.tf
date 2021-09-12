output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.mysql.address
}
output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.mysql.username
  sensitive   = true
}
output "rds_password" {
  description = "RDS instance password"
  value       = aws_db_instance.mysql.password
  sensitive   = true
}
output "elb_publicip" {
  description = "The Public IP name of the ELB"
  value       = aws_eip.eip_nlb.public_ip
}
