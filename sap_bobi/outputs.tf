output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db_oracle.db_instance_address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db_oracle.db_instance_arn
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db_oracle.db_instance_availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db_oracle.db_instance_endpoint
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.db_oracle.db_instance_hosted_zone_id
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.db_oracle.db_instance_id
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.db_oracle.db_instance_resource_id
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = module.db_oracle.db_instance_status
}

output "db_instance_name" {
  description = "The database name"
  value       = module.db_oracle.db_instance_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.db_oracle.db_instance_username
  sensitive   = true
}

output "db_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.db_oracle.db_instance_password
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = module.db_oracle.db_instance_port
}

output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.db_oracle.db_subnet_group_id
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.db_oracle.db_subnet_group_arn
}

output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.db_oracle.db_parameter_group_id
}

output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.db_oracle.db_parameter_group_arn
}

output "fsx_id" {
  value = module.windows_file_system.id
}

output "fsx_arn" {
  value = module.windows_file_system.arn
}

output "fsx_dns_name" {
  value = module.windows_file_system.dns_name
}

output "fsx_vpc_id" {
  value = module.windows_file_system.vpc_id
}

output "fsx_preferred_file_server_ip" {
  value = module.windows_file_system.preferred_file_server_ip
}

output "aws_security_group_ec2_arn" {
  value = join("", aws_security_group.ec2_rds.*.arn)
}

output "aws_security_group_ec2_id" {
  value = join("", aws_security_group.ec2_rds.*.id)
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = module.ec2_bobi_launch_template.id
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = module.ec2_bobi_launch_template.arn
}

output "launch_template_version" {
  description = "The VERSION of the launch template"
  value       = module.ec2_bobi_launch_template.version
}
