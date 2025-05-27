output "vpc_ids" {
  description = "IDs of the created VPCs"
  value       = { for k, v in aws_vpc.vpc : k => v.id }
}