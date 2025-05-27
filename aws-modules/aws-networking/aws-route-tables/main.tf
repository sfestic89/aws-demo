resource "aws_route_table" "route_tables" {
  for_each = var.route_tables

  vpc_id = each.value.vpc_id

  tags = merge(each.value.tags, {
    Name = each.key
  })

  dynamic "route" {
    for_each = try(each.value.routes, [])
    content {
      cidr_block                = lookup(route.value, "cidr_block", null)
      ipv6_cidr_block           = lookup(route.value, "ipv6_cidr_block", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
    }
  }
}

resource "aws_route_table_association" "route_tables" {
  for_each = {
    for assoc in flatten([
      for rt_key, rt in var.route_tables : [
        for subnet_id in rt.subnet_ids : {
          key            = "${rt_key}-${subnet_id}"
          subnet_id      = subnet_id
          route_table_id = aws_route_table.route_tables[rt_key].id
        }
      ]
    ]) : assoc.key => assoc
  }

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}

