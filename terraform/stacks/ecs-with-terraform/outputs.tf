output "tags" {
  description = "Map of tags used"
  value       = module.naming.tags
}

output "bastion_id" {
  description = "ID of the ec2 instance created"
  value       = module.bastion.instance_id
}

output "module_ecs" {
  description = "module ecs"
  value       = module.ecs
}
