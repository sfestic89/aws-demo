module "subnets" {
  source              = "../../aws-modules/aws-networking/aws-subnet"

  subnets = {
    "dev-public-1" = {
      vpc_id                  = module.vpc.vpc_ids["dev"]
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
      tags = {
        Tier = "public"
      }
    },
    "dev-private-1" = {
      vpc_id                  = module.vpc.vpc_ids["dev"]
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
      tags = {
        Tier = "private"
      }
    }
  }
}