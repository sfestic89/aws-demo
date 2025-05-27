resource "aws_vpc_peering_connection" "this" {
  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = var.accepter_vpc_id
  peer_region   = var.peer_region
  auto_accept   = var.auto_accept

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )

  # Optional: for cross-account
  peer_owner_id = var.peer_owner_id
}