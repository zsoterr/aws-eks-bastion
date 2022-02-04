output "asg_bastion_sg_id" {
  description = "ID of ASG of bastion host"
  value       = module.bastion-asg.this_autoscaling_group_id
}

output "asg_bastion_sg_name" {
  description = "Name of ASG of bastion host"
  value       = module.bastion-asg.this_autoscaling_group_id
}
