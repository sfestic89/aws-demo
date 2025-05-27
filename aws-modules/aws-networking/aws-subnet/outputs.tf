output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = { for k, v in aws_subnet.subnet : k => v.id }
}