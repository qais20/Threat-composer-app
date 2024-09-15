# Define ECS Cluster
resource "aws_ecs_cluster" "tm_cluster" {
  name = "tm-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

}

# ECS Task Definition
resource "aws_ecs_task_definition" "tm_task" {
  family                   = "tm-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "tm-container"
    image     = "767398132018.dkr.ecr.us-east-1.amazonaws.com/mohammedsayed/threat-composer:latest"
    cpu       = 0
    essential = true

    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
      protocol      = "tcp"
      appProtocol   = "http"
    }]

  }])

  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }
}

# ECS Service Definition
resource "aws_ecs_service" "tm_service" {
  name            = "tm-service"
  cluster         = aws_ecs_cluster.tm_cluster.id
  task_definition = aws_ecs_task_definition.tm_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.tm_public_subnet_1.id, aws_subnet.tm_public_subnet_2.id]
    security_groups  = [aws_security_group.tm_ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tm_target_group.arn
    container_name   = "tm-container"
    container_port   = 3000
  }

  deployment_controller {
    type = "ECS"
  }

  depends_on = [aws_lb_listener.tm_http]
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}