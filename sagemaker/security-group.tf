resource "aws_security_group" "sagemaker_studio_domain_sg" {
  name = "${var.prefix_resource_name}-${var.app_name}-studio-domain-sg"
  description = "Security group for sagemaker_studio_domain"
  vpc_id = var.vpc_id
  ingress {
    description = "Allow all inbound traffic from VPC"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic to VPC"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "sagemaker_studio_domain_sg_1" {
  security_group_id = aws_security_group.sagemaker_studio_domain_sg.id
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = -1
  source_security_group_id = aws_security_group.sagemaker_studio_domain_sg.id
}

// se van a crear sg por defecto, ya los probamos y no se puede crear y asociarlos