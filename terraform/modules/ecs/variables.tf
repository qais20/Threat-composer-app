variable "ecs_task_defintion_id" {
  type        = string
  description = "The id of the ECS task defintion"
  default     = "aws_ecs_task_definition.my-tm-task.arn"
}

variable "image_id" {
  type        = string
  description = "The image id from ECR"
  default     = "009160072276.dkr.ecr.eu-west-2.amazonaws.com/qais/threat-project:latest"
}

variable "policy_arn" {
  type        = string
  description = "ARN of the policy"
  default     = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

variable "security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
  description = "The ARN of the target group for the ECS service"
}

variable "http_lb_listener" {
  type = string
}

variable "https_lb_listener" {
  type = string
}
