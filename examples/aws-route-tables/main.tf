module "route_tables" {
  source = "../../aws-modules/aws-networking/aws-route-tables"

  route_tables = {
    public-rt = {
      vpc_id = module.vpc.vpc_ids["prod"]
      tags = {
        Tier = "public"
      }
      routes = [
        {
          cidr_block = "0.0.0.0/0"
          gateway_id = module.igw-prod.igw_id
        }
      ]
      subnet_ids = [module.subnets.subnet_ids["prod-public-1"]]

    },

    private-rt = {
      vpc_id = module.vpc.vpc_ids["dev"]
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.nat.id
        }
      ]
      subnet_ids = [
        module.subnets.subnet_ids["dev-private-1"]
      ]
    }
  }
}