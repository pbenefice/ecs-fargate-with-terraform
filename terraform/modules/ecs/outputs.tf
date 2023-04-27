output "cluster_id" {
  description = "ID of the created ecs cluster"
  value       = aws_ecs_cluster.this.id
}

output "lb_dns_name" {
  description = "The dns name of the created load balancer"
  value       = aws_lb.this.dns_name
}
