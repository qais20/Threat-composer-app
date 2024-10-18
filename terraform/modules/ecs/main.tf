# ECS Configure
resource "aws_ecs_cluster" "my-app-cluster" {
  name = "my-app-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


# ECS Task Definiton 
resource "aws_ecs_task_definition" "my-tm-task" {
  family                   = "my-tm-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "1024"
  memory                   = "3072"

  container_definitions = jsonencode([
    {
      name      = "tm-container"
      image     = var.image_id
      cpu       = 0
      essential = true
      portMappings = [{
        containerPort = 3000
        hostPort      = 3000
        protocol      = "tcp"
        appProtocol   = "http"
      }]
    }
  ])
}

resource "aws_ecs_service" "my-tm-service" {
  name            = "my-tm-service"
  cluster         = aws_ecs_cluster.my-app-cluster.id
  task_definition = aws_ecs_task_definition.my-tm-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    subnets          = var.subnet_ids 
    security_groups  = [var.security_group_id] 
  }

  load_balancer {
    target_group_arn = var.target_group_arn 
    container_name   = "tm-container"
    container_port   = 3000
  }

  deployment_controller {
    type = "ECS"
  }

  depends_on = [var.http_lb_listener, var.https_lb_listener] 
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.policy_arn
}
