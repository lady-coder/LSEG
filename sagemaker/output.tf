output "sagemaker_endpoint" {
  value = aws_sagemaker_domain.studio.url
}

output "sagemaker_efs_id" {
  value = aws_sagemaker_domain.studio.home_efs_file_system_id
}

