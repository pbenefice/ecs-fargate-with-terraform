locals {
  myapp_config_fileset = fileset("${path.module}/artifacts", "{conf.d,html}/*")
  myapp_config_hash = sha256(join("-", [
    for file in local.myapp_config_fileset :
    filesha256("${path.module}/artifacts/${file}")
  ]))
}

resource "aws_s3_bucket_object" "myapp_config" {
  for_each = local.myapp_config_fileset

  bucket = aws_s3_bucket.ecs_artifacts.id
  key    = "${local.app_name}/${each.value}"
  source = "${path.module}/artifacts/${each.value}"
  etag   = filemd5("${path.module}/artifacts/${each.value}")
}

resource "aws_s3_bucket" "ecs_artifacts" {
  bucket = lower("${local.prefix}-ecs-artifacts")
}
# resource "aws_s3_bucket_acl" "ecs_artifacts" {
#   bucket = aws_s3_bucket.ecs_artifacts.id
#   acl = "private"
# }
resource "aws_s3_bucket_versioning" "ecs_artifacts" {
  bucket = aws_s3_bucket.ecs_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}
