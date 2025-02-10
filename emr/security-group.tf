resource "aws_security_group" "emr_master_sg" {
  name = "emr_master_sg"
  description = "Security group for EMR master"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "emr_slave_sg" {
  name = "emr_slave_sg"
  description = "Security group for EMR slave"  
  vpc_id = var.vpc_id
}

resource "aws_security_group" "emr_service_sg" {
  name = "emr_service_sg"
  description = "Security group for EMR service"
  vpc_id = var.vpc_id
}

// master
resource "aws_security_group_rule" "emr_master_sg_ingress_1" {
  security_group_id = aws_security_group.emr_master_sg.id //to which belong
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "udp"
  source_security_group_id = aws_security_group.emr_master_sg.id
}
resource "aws_security_group_rule" "emr_master_sg_ingress_2" {
  security_group_id = aws_security_group.emr_master_sg.id //to which belong
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  source_security_group_id = aws_security_group.emr_master_sg.id
}
resource "aws_security_group_rule" "emr_master_sg_ingress_3" {
  security_group_id = aws_security_group.emr_master_sg.id //to which belong
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = "icmp"
  source_security_group_id = aws_security_group.emr_master_sg.id
}
# resource "aws_security_group_rule" "emr_master_sg_ingress_4" {
#   security_group_id = aws_security_group.emr_master_sg.id //to which belong
#   type = "ingress"
#   from_port = 22
#   to_port = 22
#   protocol = "tcp"
#   prefix_list_ids = var.prefix_list_ids
# }
resource "aws_security_group_rule" "emr_master_sg_ingress_5" {
  security_group_id = aws_security_group.emr_master_sg.id //to which belong
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  source_security_group_id = aws_security_group.emr_slave_sg.id
}
resource "aws_security_group_rule" "emr_master_sg_ingress_6" {
  security_group_id = aws_security_group.emr_master_sg.id //to which belong
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "udp"
  source_security_group_id = aws_security_group.emr_slave_sg.id
}
resource "aws_security_group_rule" "emr_master_sg_ingress_7" {
  security_group_id = aws_security_group.emr_master_sg.id //to which belong
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = "icmp"
  source_security_group_id = aws_security_group.emr_slave_sg.id
}




resource "aws_security_group_rule" "emr_master_sg_ingress_8" {
  security_group_id = aws_security_group.emr_master_sg.id //TEST WITH https://docs.aws.amazon.com/sagemaker/latest/dg/studio-notebooks-emr-networking.html
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
}
  # EMRMasterSageMakerTCP8998SecurityGroup:
  #   Type: AWS::EC2::SecurityGroupIngress
  #   Properties:
  #     IpProtocol: tcp
  #     FromPort: 8998
  #     ToPort: 8998
  #     GroupId: !GetAtt EMRMasterSecurityGroup.GroupId
  #     SourceSecurityGroupId: !GetAtt SageMakerSecurityGroup.GroupId

  # EMRMasterSageMakerTCP10000SecurityGroup:
  #   Type: AWS::EC2::SecurityGroupIngress
  #   Properties:
  #     IpProtocol: tcp
  #     FromPort: 10000
  #     ToPort: 10000
  #     GroupId: !GetAtt EMRMasterSecurityGroup.GroupId
  #     SourceSecurityGroupId: !GetAtt SageMakerSecurityGroup.GroupId


# resource "aws_security_group_rule" "emr_master_sg_ingress_8" {
#   security_group_id = aws_security_group.emr_master_sg.id //to which belong
#   type = "ingress"
#   from_port = 18080
#   to_port = 18080
#   protocol = "tcp"
#   prefix_list_ids = var.prefix_list_ids
#   description = "spark history server port"
# }

#resource "aws_security_group_rule" "emr_master_sg_ingress_8" {
#  security_group_id = aws_security_group.emr_master_sg.id //to which belong
#  type = "ingress"
#  from_port = 8443
#  to_port = 8443
#  protocol = "tcp"
#  source_security_group_id = aws_security_group.emr_service_sg.id
#}
# resource "aws_security_group_rule" "emr_master_sg_ingress_9" {
#   security_group_id = aws_security_group.emr_master_sg.id //to which belong
#   type = "ingress"
#   from_port = 8998
#   to_port = 8998
#   protocol = "tcp"
#   prefix_list_ids = var.prefix_list_ids
#   description = "livy port"
# }
# resource "aws_security_group_rule" "emr_master_sg_ingress_10" {
#   security_group_id = aws_security_group.emr_master_sg.id //to which belong
#   type = "ingress"
#   from_port = 464
#   to_port = 464
#   protocol = "tcp"
#   prefix_list_ids = var.prefix_list_ids
#   description = "kinit port"
# }
# resource "aws_security_group_rule" "emr_master_sg_ingress_11" {
#   security_group_id = aws_security_group.emr_master_sg.id //to which belong
#   type = "ingress"
#   from_port = 88
#   to_port = 88
#   protocol = "tcp"
#   prefix_list_ids = var.prefix_list_ids
#   description = "kerberos port"
# }
resource "aws_security_group_rule" "emr_master_sg_ingress_12" {
  security_group_id = aws_security_group.emr_master_sg.id //to which belong
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = aws_security_group.emr_service_sg.id
  description = "all traffic _ service emr sg"
}
resource "aws_security_group_rule" "emr_master_sg_ingress_13" {
  security_group_id = aws_security_group.emr_master_sg.id //to which belong
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = aws_security_group.emr_slave_sg.id
  description = "all traffic _ slave emr sg"
}
# resource "aws_security_group_rule" "emr_master_sg_ingress_14" {
#   security_group_id = aws_security_group.emr_master_sg.id //to which belong
#   type = "ingress"
#   from_port = 8889
#   to_port = 8889
#   protocol = "tcp"
#   prefix_list_ids = var.prefix_list_ids
#   description = "http 8889 trino _ all private"
# }

# resource "aws_security_group_rule" "emr_master_sg_ingress_15" {
#   security_group_id = aws_security_group.emr_master_sg.id //to which belong
#   type = "ingress"
#   from_port = 8888
#   to_port = 8888
#   protocol = "tcp"
#   prefix_list_ids = var.prefix_list_ids
#   description = "http 8888 hue _ all private"
# }

# resource "aws_security_group_rule" "emr_master_sg_ingress_16" {
#   security_group_id = aws_security_group.emr_master_sg.id //to which belong
#   type = "ingress"
#   from_port = 18480
#   to_port = 18480
#   protocol = "tcp"
#   prefix_list_ids = var.prefix_list_ids
#   description = "spark history server porte _ all private"
# }

# resource "aws_security_group_rule" "emr_master_sg_ingress_16" {
#   security_group_id = aws_security_group.emr_master_sg.id //to which belong
#   type = "ingress"
#   from_port = 8443
#   to_port = 8443
#   protocol = "tcp"
#   source_security_group_id = aws_security_group.emr_service_sg.id
#   description = "8443 port from master to service"
# }

resource "aws_security_group_rule" "emr_master_sg_egress_1" {
  security_group_id = aws_security_group.emr_master_sg.id //to which belong
  type = "egress"
  from_port = -1
  to_port = -1
  protocol = -1
  cidr_blocks = [ "0.0.0.0/0" ]
}


// slave
resource "aws_security_group_rule" "emr_slave_sg_ingress_1" {
  security_group_id = aws_security_group.emr_slave_sg.id //to which belong
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "udp"
  source_security_group_id = aws_security_group.emr_master_sg.id
}
resource "aws_security_group_rule" "emr_slave_sg_ingress_2" {
  security_group_id = aws_security_group.emr_slave_sg.id //to which belong
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  source_security_group_id = aws_security_group.emr_master_sg.id
}
resource "aws_security_group_rule" "emr_slave_sg_ingress_3" {
  security_group_id = aws_security_group.emr_slave_sg.id //to which belong
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = "icmp"
  source_security_group_id = aws_security_group.emr_master_sg.id
}
resource "aws_security_group_rule" "emr_slave_sg_ingress_4" {
  security_group_id = aws_security_group.emr_slave_sg.id //to which belong
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "udp"
  source_security_group_id = aws_security_group.emr_slave_sg.id
}
resource "aws_security_group_rule" "emr_slave_sg_ingress_5" {
  security_group_id = aws_security_group.emr_slave_sg.id //to which belong
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  source_security_group_id = aws_security_group.emr_slave_sg.id
}
resource "aws_security_group_rule" "emr_slave_sg_ingress_6" {
  security_group_id = aws_security_group.emr_slave_sg.id //to which belong
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = "icmp"
  source_security_group_id = aws_security_group.emr_slave_sg.id
}
resource "aws_security_group_rule" "emr_slave_sg_ingress_7" {
  security_group_id = aws_security_group.emr_slave_sg.id //to which belong
  type = "ingress"
  from_port = 8443
  to_port = 8443
  protocol = "tcp"
  source_security_group_id = aws_security_group.emr_service_sg.id
}
resource "aws_security_group_rule" "emr_slave_sg_ingress_8" {
  security_group_id = aws_security_group.emr_slave_sg.id //to which belong ITS NOT IN CFN
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = aws_security_group.emr_service_sg.id
  description = "all traffic _ service emr sg"
}
resource "aws_security_group_rule" "emr_slave_sg_ingress_9" {
  security_group_id = aws_security_group.emr_slave_sg.id //to which belong ITS NOT IN CFN
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = aws_security_group.emr_master_sg.id
  description = "all traffic _ master emr sg"
}
resource "aws_security_group_rule" "emr_slave_sg_egress_1" {
  security_group_id = aws_security_group.emr_slave_sg.id //to which belong
  type = "egress"
  from_port = -1
  to_port = -1
  protocol = -1
  cidr_blocks = [ "0.0.0.0/0" ]
}

// service
resource "aws_security_group_rule" "emr_service_sg_ingress_1" {
  security_group_id = aws_security_group.emr_service_sg.id //to which belong
  type = "ingress"
  from_port = 9443
  to_port = 9443
  protocol = "tcp"
  source_security_group_id = aws_security_group.emr_master_sg.id
}
resource "aws_security_group_rule" "emr_service_sg_egress_1" {
  security_group_id = aws_security_group.emr_service_sg.id //to which belong
  type = "egress"
  from_port = 8443
  to_port = 8443
  protocol = "tcp"
  source_security_group_id = aws_security_group.emr_master_sg.id
}
resource "aws_security_group_rule" "emr_service_sg_egress_2" {
  security_group_id = aws_security_group.emr_service_sg.id //to which belong
  type = "egress"
  from_port = 8443
  to_port = 8443
  protocol = "tcp"
  source_security_group_id = aws_security_group.emr_slave_sg.id
}

resource "aws_security_group_rule" "emr_service_sg_egress_3" {
  security_group_id = aws_security_group.emr_service_sg.id //to which belong
  type = "egress"
  from_port = -1
  to_port = -1
  protocol = -1
  cidr_blocks = [ "0.0.0.0/0" ]
}
