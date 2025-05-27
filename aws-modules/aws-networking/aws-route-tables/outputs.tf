output "route_table_ids" {
  description = "Map of route table names to IDs"
  value = { for k, rt in aws_route_table.route_tables : k => rt.id }
}