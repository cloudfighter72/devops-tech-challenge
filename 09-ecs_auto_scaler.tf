# --- BACKEND AUTO SCALING ---
resource "aws_appautoscaling_target" "backend_target" {
  max_capacity       = var.ecs_max_capacity
  min_capacity       = var.ecs_min_capacity
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.backend_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "backend_cpu_policy" {
  name               = "backend-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.backend_target.resource_id
  scalable_dimension = aws_appautoscaling_target.backend_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.backend_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.autoscaling_target_cpu

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

# --- FRONTEND AUTO SCALING ---
resource "aws_appautoscaling_target" "frontend_target" {
  max_capacity       = var.ecs_max_capacity
  min_capacity       = var.ecs_min_capacity
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.frontend_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "frontend_cpu_policy" {
  name               = "frontend-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.frontend_target.resource_id
  scalable_dimension = aws_appautoscaling_target.frontend_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.frontend_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.autoscaling_target_cpu

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}