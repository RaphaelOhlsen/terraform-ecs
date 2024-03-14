variable "ecs_ec2_id" {}
variable "subnet_id" {}

output "ecs_arn" {
  value = aws_autoscaling_group.ecs.arn
}

resource "aws_autoscaling_group" "ecs" {
  name_prefix               = "demo-ecs-asg"
  vpc_zone_identifier       = var.subnet_id
  min_size                  = 2
  max_size                  = 8
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false

  launch_template {
    id      = var.ecs_ec2_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "demo-ecs-cluster"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}