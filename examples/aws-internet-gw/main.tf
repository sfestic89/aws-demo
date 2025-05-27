module "igw" {
  source = "../../aws-modules/aws-networking/aws-internet-gw"

  vpc_id = module.vpc.vpc_ids["dev"]
  name   = "dev-igw"
  tags = {
    Environment = "dev"
  }
}