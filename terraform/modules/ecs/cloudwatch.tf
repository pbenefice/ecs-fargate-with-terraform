resource "aws_cloudwatch_log_group" "myapp" {
  name = "${local.prefix}-ecs-${local.app_name}"

  retention_in_days = 90
}
