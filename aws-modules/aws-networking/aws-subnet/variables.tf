variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    vpc_id                  = string
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
    tags                    = optional(map(string), {})
  }))
}