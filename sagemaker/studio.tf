resource "aws_sagemaker_domain" "sagemaker_studio_domain" {
  domain_name= "${var.prefix_resource_name}-${var.app_name}-studio-domain"
  auth_mode = "IAM"
  app_network_access_type = "VpcOnly"
  # app_security_group_management = "Service"
  vpc_id = var.vpc_id
  # kms_key_id = var.key_kms_arn
  subnet_ids = var.subnet_private_list
  
  default_space_settings {
    execution_role = aws_iam_role.sagemaker_execution_role.arn
    security_groups = [aws_security_group.sagemaker_studio_domain_sg.id]
  }
  default_user_settings {
    execution_role = aws_iam_role.sagemaker_studio_user_role.arn
    security_groups = [aws_security_group.sagemaker_studio_domain_sg.id]
  }

}
