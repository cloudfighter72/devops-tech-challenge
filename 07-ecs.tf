# ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name

  tags = {
    Name = "${var.project_name}-ecs-cluster"
  }
}

# --- BACKEND ---
resource "aws_ecs_task_definition" "backend_task" {
  family                   = "${var.project_name}-backend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.backend_cpu
  memory                   = var.backend_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${aws_ecr_repository.backend.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "backend_service" {
  name            = "${var.project_name}-backend-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.ecs_desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 8080
  }

  network_configuration {
    subnets          = [aws_subnet.public_1.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

# --- FRONTEND ---
resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "${var.project_name}-frontend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.frontend_cpu
  memory                   = var.frontend_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "${aws_ecr_repository.frontend.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "frontend_service" {
  name            = "${var.project_name}-frontend-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.frontend_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.ecs_desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 80
  }

  network_configuration {
    subnets          = [aws_subnet.public_1.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}