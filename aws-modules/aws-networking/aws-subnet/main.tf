resource "aws_subnet" "subnet" {
  for_each = var.subnets

  vpc_id                  = each.value.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(
    each.value.tags,
    {
      Name = each.key
    }
  )
}