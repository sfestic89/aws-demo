module "nacls" {
  source = "../../aws-modules/aws-networking/aws-nacl"

  nacls = {
    public-nacl = {
      vpc_id     = module.vpc.vpc_ids["dev"]
      subnet_ids = [module.subnets.subnet_ids["dev-public-1"]]
      tags = {
        Tier = "public"
      }
      ingress = [
        {
          rule_no     = 100
          protocol    = "tcp"
          action      = "allow"
          cidr_block  = "0.0.0.0/0"
          from_port   = 80
          to_port     = 80
        }
      ]
      egress = [
        {
          rule_no     = 200
          protocol    = "-1"
          action      = "allow"
          cidr_block  = "0.0.0.0/0"
          from_port   = 0
          to_port     = 0
        }
      ]
    }

    private-nacl = {
      vpc_id     = module.vpc.vpc_ids["dev"]
      subnet_ids = [module.subnets.subnet_ids["dev-private-1"]]
      ingress    = []
      egress     = []
    }
  }
}
