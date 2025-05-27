variable "requester_vpc_id" {
  description = "The VPC ID of the requester (this side of the peering connection)"
  type        = string
}

variable "accepter_vpc_id" {
  description = "The VPC ID of the peer (the other side of the connection)"
  type        = string
}

variable "peer_region" {
  description = "Region of the peer VPC (set if cross-region)"
  type        = string
  default     = null
}

variable "peer_owner_id" {
  description = "The AWS account ID of the peer VPC (for cross-account peering)"
  type        = string
  default     = null
}

variable "auto_accept" {
  description = "Whether to auto-accept the peering (only works within same account)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name tag for the peering connection"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to the VPC peering connection"
  type        = map(string)
  default     = {}
}
