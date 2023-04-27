resource "aws_ecs_task_definition" "myapp" {
  family                   = "${local.prefix}-${local.app_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  task_role_arn      = aws_iam_role.ecs_task_role_myapp.arn
  execution_role_arn = aws_iam_role.ecs_execution_role_myapp.arn

  container_definitions = jsonencode([
    {
      name    = local.app_name
      image   = "nginx:1.24.0"
      cpu     = 1024
      memory  = 2048
      # command = [
      #   "sh",
      #   "-c",
      #   "echo 'Hello World!' && sleep 3600"
      # ]

      linuxParameters = {
        "initProcessEnabled"= true
      }

      logConfiguration = {
          "logDriver" = "awslogs",
          "options" = {
              "awslogs-group" = aws_cloudwatch_log_group.myapp.name,
              "awslogs-region" = local.region,
              "awslogs-stream-prefix" = "myapp"
          }
      },

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ],

    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "myapp" {
  name            = "${local.prefix}-${local.app_name}"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.myapp.arn
  desired_count   = 1

  enable_execute_command = true

  launch_type = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.myapp.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.myapp.arn
    container_name   = local.app_name
    container_port   = 80
  }

  depends_on = [aws_lb_listener.myapp]
}
