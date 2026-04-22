provider "aws" {
  region = "ap-south-1"
}

resource "aws_ecr_repository" "repo" {
  name = "coffee-shop-app"
}

resource "aws_ecs_cluster" "cluster" {
  name = "coffee-cluster"
}

resource "aws_iam_role" "ecs_role" {
  name = "ecsTaskExecutionRoleCoffee"

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "policy" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "coffee-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_role.arn

  container_definitions = jsonencode([
    {
      name  = "coffee-app"
      image = "${aws_ecr_repository.repo.repository_url}:latest"
      portMappings = [{
        containerPort = 3000
      }]
    }
  ])
}