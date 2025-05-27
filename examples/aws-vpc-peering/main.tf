module "vpc_peering" {
  source = "../../aws-modules/aws-networking/aws-vpc-peering"

  requester_vpc_id = module.vpc_1.vpc_ids["dev"]
  accepter_vpc_id  = module.vpc_2.vpc_ids["prod"]
  name             = "dev-to-prod"
  tags = {
    Environment = "shared"
  }
}