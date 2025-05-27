resource "aws_vpc" "vpc" {
  for_each = var.vpcs

  cidr_block           = each.value.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    each.value.tags,
    {
      Name = "${each.key}-vpc"
    }
  )
}