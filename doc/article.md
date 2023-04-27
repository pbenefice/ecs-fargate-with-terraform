# ECS with terraform

## Prerequis

Nous considérerons ici que certains éléments existent déjà dans le compte AWS ou nous ferons nos tests. Notamment un VPC configuré avec des réseaux privé ayant un accès a internet via une NAT Gateway.  
Le repository de démonstration contient du code permettant de mettre en place ces prerequis si necessaire.  

## Cluster et 1er container

Commençons par créer le cluster et faire tourner un simple container dessus.  
Il nous faut donc :
- un cluster et un log group associé,
- un service & une task definition,
- un rôle iam (qui permettra à terme de donner des droits au container),
- un security group

Nous prendrons une image Debian pour faciliter les tests dans un premier temps. Le code ressemble donc à :  

```terraform
locals {
  prefix   = "${var.project_prefix}-${var.env}"
  app_name = "myapp"
}

resource "aws_cloudwatch_log_group" "ecs_cluster" {
  name = "${local.prefix}-ecs-cluster"
}
resource "aws_ecs_cluster" "this" {
  name = local.prefix

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs_cluster.name
      }
    }
  }
}

resource "aws_ecs_task_definition" "myapp" {
  family                   = "${local.prefix}-${local.app_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  task_role_arn = aws_iam_role.ecs_task_role_myapp.arn

  container_definitions = jsonencode([
    {
      name   = local.app_name
      image  = "debian:buster-20230411-slim"
      cpu    = 1024
      memory = 2048

      command         = [ "sleep", "3600" ],
      linuxParameters = {
        "initProcessEnabled"= true
      }
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
}

resource "aws_iam_role" "ecs_task_role_myapp" {
  name = "${local.prefix}-ecs-task-role-${local.app_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "requirements-for-ecs-exec"

    policy = jsonencode({
      Version: "2012-10-17",
      Statement: []
    })
  }
}

resource "aws_security_group" "myapp" {
  name        = "${local.prefix}-ecs-${local.app_name}"
  description = "manage rules for ${local.app_name} ecs service"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
```

We now have a first container running on aws :  
![cluster-1st-container-running](./img/cluster-1st-container-running.png)  
