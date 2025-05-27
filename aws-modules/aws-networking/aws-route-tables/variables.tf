variable "route_tables" {
  description = "Map of route tables with their routes and subnet associations"
  type = map(object({
    vpc_id     = string
    tags       = optional(map(string), {})
    routes     = optional(list(map(string)), [])
    subnet_ids = optional(list(string), [])
  }))
}