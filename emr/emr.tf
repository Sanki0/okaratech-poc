resource "aws_s3_bucket" "logs_bucket" {
  bucket        = "${var.prefix_resource_name}-logs-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket = aws_s3_bucket.logs_bucket.bucket
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_emr_cluster" "emr_cluster" {
  name          = "${var.prefix_resource_name} - ${var.app_name}"
  release_label = "${var.emr_release_label}"
  applications  = ["Hadoop", "Hive", "Livy", "Spark", "ZooKeeper"]
  
  
  #configurations_json = file("./soft-conf.json")
  keep_job_flow_alive_when_no_steps = true
  ec2_attributes {
    emr_managed_master_security_group = aws_security_group.emr_master_sg.id
    emr_managed_slave_security_group  = aws_security_group.emr_slave_sg.id
    instance_profile                  = aws_iam_instance_profile.emr_ec2_instance_profile_role.name
    # key_name                          = "${var.app_name}-cluster-key-pair-${var.stage}"                                  //como se hara el key pair?
    service_access_security_group     = aws_security_group.emr_service_sg.id
    subnet_ids                        = var.subnet_private_list
  }

  log_uri = "s3://${aws_s3_bucket.logs_bucket.id}/emr-logs/"
  #log_encryption_kms_key_id = var.key-kms-id //importar el kms key id
  master_instance_fleet {
    name = "Primary"
    target_on_demand_capacity = 1
    instance_type_configs {
      instance_type = var.emr_master_instance_type
      weighted_capacity = 1
      bid_price_as_percentage_of_on_demand_price = 100
      ebs_config {
        iops = 0
        size = 32
        type = "gp3"
        volumes_per_instance = 2
      }
    }
    launch_specifications {
      on_demand_specification {
        allocation_strategy = "lowest-price"
      }
    }
  }
  core_instance_fleet {
    name = "Core"
    target_on_demand_capacity = 1
    target_spot_capacity = 0
    #provisioned_on_demand_capacity = 4
    #provisioned_spot_capacity = 0
    instance_type_configs {
      instance_type = var.emr_core_instance_type
      weighted_capacity = 1
      bid_price_as_percentage_of_on_demand_price = 2
      ebs_config {
        iops = 0
        size = 32
        type = "gp3"
        volumes_per_instance = 2
      }
    }
    launch_specifications {
      on_demand_specification {
        allocation_strategy = "lowest-price"
      }
      spot_specification {
        block_duration_minutes = 300
        timeout_action = "SWITCH_TO_ON_DEMAND"
        timeout_duration_minutes = 1440
        allocation_strategy = "lowest-price"
      }
    }
  }
  service_role = aws_iam_role.emr_role.arn
  #step_concurrency_level = 256
  
  termination_protection = false
  scale_down_behavior = "TERMINATE_AT_TASK_COMPLETION"
}

resource "aws_emr_instance_fleet" "emr_instance_fleet" {
  cluster_id = aws_emr_cluster.emr_cluster.id
  name = "Task"
  target_on_demand_capacity = 1
  target_spot_capacity = 0
  instance_type_configs {
    instance_type = var.emr_core_instance_type
    weighted_capacity = 1
    bid_price_as_percentage_of_on_demand_price = 100
    ebs_config {
      iops = 0
      size = 32
      type = "gp3"
      volumes_per_instance = 2
    }
  }
  launch_specifications {
    on_demand_specification {
      allocation_strategy = "lowest-price"
    }
  }
}

resource "aws_emr_managed_scaling_policy" "emr_managed_scaling_policy" {
  cluster_id = aws_emr_cluster.emr_cluster.id
  compute_limits {
    unit_type = "InstanceFleetUnits"
    minimum_capacity_units = 1
    maximum_capacity_units = 10
  }
  
}