variable "vpcs" {
  description = "Map of VPC names to configuration"
  type = map(object({
    cidr_block = string
    tags       = optional(map(string), {})
  }))
}