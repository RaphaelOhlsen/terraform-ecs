#######################
# ECS Launch Template #
#######################

variable "ecs_node_arn" {}
variable "ecs_cluster_name" {}
variable "sg_id" {}
variable "ec2_key_name" {}

output "ecs_ec2_id" {
  value = aws_launch_template.ecs_ec2.id
}


data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "ecs_ec2" {
  name_prefix            = "demo-ecs-ec2-"
  image_id               = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type          = "t2.micro"
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [var.sg_id]

  iam_instance_profile { arn = var.ecs_node_arn }
  monitoring { enabled = true }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config;
    EOF
  )
}