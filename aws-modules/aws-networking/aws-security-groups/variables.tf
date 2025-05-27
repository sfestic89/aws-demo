variable "security_groups" {
  description = "Map of security groups to create with their rules"
  type = map(object({
    description = string
    vpc_id      = string
    tags        = optional(map(string), {})
    ingress = optional(list(object({
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = optional(list(string))
      ipv6_cidr_blocks = optional(list(string))
      description      = optional(string)
      security_groups  = optional(list(string))
    })), [])
    egress = optional(list(object({
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = optional(list(string))
      ipv6_cidr_blocks = optional(list(string))
      description      = optional(string)
      security_groups  = optional(list(string))
    })), [])
  }))
}
