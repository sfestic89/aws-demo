output "nacl_ids" {
  description = "IDs of created Network ACLs"
  value = { for k, v in aws_network_acl.this : k => v.id }
}