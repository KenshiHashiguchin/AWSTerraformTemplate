locals {
  user_user_data = <<DATA
#!/bin/bash
echo ECS_CLUSTER=${terraform.workspace}-user-main >> /etc/ecs/ecs.config;
echo ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=${var.ec2[terraform.workspace].ecs_engine_task_cleanup_wait_duration} >> /etc/ecs/ecs.config;
echo "ECS_AVAILABLE_LOGGING_DRIVERS=[\"awslogs\",\"fluentd\"]" >> /etc/ecs/ecs.config
DATA
  admin_user_data = <<DATA
#!/bin/bash
echo ECS_CLUSTER=${terraform.workspace}-admin-main >> /etc/ecs/ecs.config;
echo ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=${var.ec2[terraform.workspace].ecs_engine_task_cleanup_wait_duration} >> /etc/ecs/ecs.config;
echo "ECS_AVAILABLE_LOGGING_DRIVERS=[\"awslogs\",\"fluentd\"]" >> /etc/ecs/ecs.config
DATA

}

resource "aws_launch_template" "user-main" {
  name = "${terraform.workspace}-user-main"
  description = "ECS Public Image"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 30
    }
  }

  cpu_options {
    core_count       = var.ec2[terraform.workspace].core_count
    threads_per_core       = var.ec2[terraform.workspace].threads_per_core
  }

  credit_specification {
    cpu_credits = "standard"
  }

  ebs_optimized = true

  iam_instance_profile {
    name = data.terraform_remote_state.singleton.outputs.instance_profile.bastion.name
  }

  image_id = var.ec2.image_id
  instance_type = var.ec2[terraform.workspace].instance_type
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids = [aws_security_group.instance[0].id] //ユーザ側のSG
  key_name = data.terraform_remote_state.singleton.outputs.key_pair.app_key_name

  instance_market_options {
    market_type = var.ec2[terraform.workspace].market_type
  }
  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${terraform.workspace}-user-main"
      Environment = terraform.workspace
    }
  }

//  user_data = base64decode("#!/bin/bash\necho ECS_CLUSTER=${var.ec2[terraform.workspace].attach_cluster} >> /etc/ecs/ecs.config")
  user_data = base64encode(local.user_user_data)
}


resource "aws_autoscaling_group" "user-main" {
  name = "${terraform.workspace}-user-asg"
  vpc_zone_identifier = aws_subnet.main-app.*.id

  desired_capacity   = var.ec2[terraform.workspace].desired_capacity
  max_size           = var.ec2[terraform.workspace].max_size
  min_size           = var.ec2[terraform.workspace].min_size

  health_check_grace_period = 300
  health_check_type = "EC2"

  launch_template {
    id      = aws_launch_template.user-main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}-user-ecs"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = terraform.workspace
    propagate_at_launch = true
  }
}

//admin
resource "aws_launch_template" "admin-main" {
  name = "${terraform.workspace}-admin-main"
  description = "ECS Public Image"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 30
    }
  }

  cpu_options {
    core_count       = var.ec2[terraform.workspace].core_count
    threads_per_core       = var.ec2[terraform.workspace].threads_per_core
  }

  credit_specification {
    cpu_credits = "standard"
  }

  ebs_optimized = true

  iam_instance_profile {
    name = data.terraform_remote_state.singleton.outputs.instance_profile.bastion.name
  }

  image_id = var.ec2.image_id
  instance_type = var.ec2[terraform.workspace].instance_type
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids = [aws_security_group.instance[1].id] //Admin側のSG
  key_name = data.terraform_remote_state.singleton.outputs.key_pair.app_key_name

  instance_market_options {
    market_type = var.ec2[terraform.workspace].market_type
  }
  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${terraform.workspace}-admin-main"
      Environment = terraform.workspace
    }
  }

  //  user_data = base64decode("#!/bin/bash\necho ECS_CLUSTER=${var.ec2[terraform.workspace].attach_cluster} >> /etc/ecs/ecs.config")
  user_data = base64encode(local.admin_user_data)
}


resource "aws_autoscaling_group" "admin-main" {
  name = "${terraform.workspace}-admin-asg"
  vpc_zone_identifier = aws_subnet.main-app.*.id

  desired_capacity   = var.ec2[terraform.workspace].desired_capacity
  max_size           = var.ec2[terraform.workspace].max_size
  min_size           = var.ec2[terraform.workspace].min_size

  health_check_grace_period = 300
  health_check_type = "EC2"

  launch_template {
    id      = aws_launch_template.admin-main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}-admin-ecs"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = terraform.workspace
    propagate_at_launch = true
  }
}
