variable "nacls" {
  description = "Map of Network ACLs and rules"
  type = map(object({
    vpc_id     = string
    subnet_ids = list(string)
    tags       = optional(map(string), {})
    ingress    = optional(list(map(any)), [])
    egress     = optional(list(map(any)), [])
  }))
}
