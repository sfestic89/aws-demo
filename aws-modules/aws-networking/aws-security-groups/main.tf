resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = each.key
  description = each.value.description
  vpc_id      = each.value.vpc_id

  tags = merge(each.value.tags, {
    Name = each.key
  })

  dynamic "ingress" {
    for_each = try(each.value.ingress, [])
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", [])
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", [])
      description      = lookup(ingress.value, "description", null)
      security_groups  = lookup(ingress.value, "security_groups", [])
    }
  }

  dynamic "egress" {
    for_each = try(each.value.egress, [])
    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = lookup(egress.value, "cidr_blocks", [])
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", [])
      description      = lookup(egress.value, "description", null)
      security_groups  = lookup(egress.value, "security_groups", [])
    }
  }
}
