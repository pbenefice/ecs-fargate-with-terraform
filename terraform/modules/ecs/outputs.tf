output "cluster_id" {
  description = "ID of the created ecs cluster"
  value       = aws_ecs_cluster.this.id
}
