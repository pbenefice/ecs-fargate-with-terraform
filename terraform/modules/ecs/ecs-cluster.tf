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
