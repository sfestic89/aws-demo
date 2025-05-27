module "vpc" {
  source = "../../aws-modules/aws-networking/aws-vpc"
  vpcs = {
    dev = {
      cidr_block = "10.0.0.0/16"
      tags = {
        Environment = "dev"
      }
    },
    prod = {
      cidr_block = "10.1.0.0/16"
      tags = {
        Environment = "prod"
      }
    }
  }
}