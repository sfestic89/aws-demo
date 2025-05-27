resource "aws_network_acl" "this" {
  for_each = var.nacls

  vpc_id     = each.value.vpc_id
  subnet_ids = each.value.subnet_ids

  dynamic "egress" {
    for_each = try(each.value.egress, [])
    content {
      rule_no         = lookup(egress.value, "rule_no", null)
      protocol        = lookup(egress.value, "protocol", null)
      action          = lookup(egress.value, "action", null)
      cidr_block      = lookup(egress.value, "cidr_block", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      from_port       = lookup(egress.value, "from_port", null)
      to_port         = lookup(egress.value, "to_port", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      icmp_code       = lookup(egress.value, "icmp_code", null)
    }
  }

  dynamic "ingress" {
    for_each = try(each.value.ingress, [])
    content {
      rule_no         = lookup(ingress.value, "rule_no", null)
      protocol        = lookup(ingress.value, "protocol", null)
      action          = lookup(ingress.value, "action", null)
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      from_port       = lookup(ingress.value, "from_port", null)
      to_port         = lookup(ingress.value, "to_port", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      icmp_code       = lookup(ingress.value, "icmp_code", null)
    }
  }

  tags = merge(each.value.tags, {
    Name = each.key
  })
}
