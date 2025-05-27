module "vpc" {
  source = "../aws-modules/aws-networking/aws-vpc"
  vpcs = {
    dev = {
      cidr_block = "10.0.0.0/16"
      tags = {
        Environment = "dev"
      }
    },
    dev-peer = {
      cidr_block = "10.2.0.0/16"
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

module "subnets" {
  source = "../aws-modules/aws-networking/aws-subnet"

  subnets = {
    "dev-public-1" = {
      vpc_id                  = module.vpc.vpc_ids["dev"]
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "eu-central-1a"
      map_public_ip_on_launch = true
      tags = {
        Tier = "public"
      }
    },
    "dev-private-1" = {
      vpc_id                  = module.vpc.vpc_ids["dev"]
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "eu-central-1b"
      map_public_ip_on_launch = false
      tags = {
        Tier = "private"
      }
    },
    "prod-public-1" = {
      vpc_id                  = module.vpc.vpc_ids["prod"]
      cidr_block              = "10.1.1.0/24"
      availability_zone       = "eu-central-1a"
      map_public_ip_on_launch = true
      tags = {
        Tier = "public"
      }
    },
    "prod-private-1" = {
      vpc_id                  = module.vpc.vpc_ids["prod"]
      cidr_block              = "10.1.2.0/24"
      availability_zone       = "eu-central-1b"
      map_public_ip_on_launch = false
      tags = {
        Tier = "private"
      }
    }
  }
}

module "igw-dev" {
  source = "../aws-modules/aws-networking/aws-internet-gw"

  vpc_id = module.vpc.vpc_ids["dev"]
  name   = "dev-igw"
  tags = {
    Environment = "dev"
  }
}

module "igw-prod" {
  source = "../aws-modules/aws-networking/aws-internet-gw"

  vpc_id = module.vpc.vpc_ids["prod"]
  name   = "prod-igw"
  tags = {
    Environment = "prod"
  }
}

module "dev_route_tables" {
  source = "../aws-modules/aws-networking/aws-route-tables"

  route_tables = {
    public-rt-dev = {
      vpc_id = module.vpc.vpc_ids["dev"]
      tags = {
        Tier = "public"
      }
      routes = [
        {
          cidr_block = "0.0.0.0/0"
          gateway_id = module.igw-dev.igw_id
        }
      ]
      subnet_ids = [module.subnets.subnet_ids["dev-public-1"]]

    }
  }
}

module "prod_route_tables" {
  source = "../aws-modules/aws-networking/aws-route-tables"

  route_tables = {
    public-rt-prod = {
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

    }
  }
}

module "nacls" {
  source = "../aws-modules/aws-networking/aws-nacl"

  nacls = {
    public-nacl = {
      vpc_id     = module.vpc.vpc_ids["dev"]
      subnet_ids = [module.subnets.subnet_ids["dev-public-1"]]
      tags = {
        Tier = "public"
      }
      ingress = [
        {
          rule_no    = 100
          protocol   = "tcp"
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 80
          to_port    = 80
        }
      ]
      egress = [
        {
          rule_no    = 200
          protocol   = "-1" # all protocols
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 0
          to_port    = 0
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

module "security_groups" {
  source = "../aws-modules/aws-networking/aws-security-groups"

  security_groups = {
    web-sg = {
      description = "Allow HTTP and HTTPS"
      vpc_id      = module.vpc.vpc_ids["dev"]
      tags = {
        Tier = "web"
      }
      ingress = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

module "dev_vpc_peering" {
  source = "../aws-modules/aws-networking/aws-vpc-peering"

  requester_vpc_id = module.vpc.vpc_ids["dev"]
  accepter_vpc_id  = module.vpc.vpc_ids["dev-peer"]
  name             = "peer-dev-env"
  tags = {
    Environment = "dev"
  }
}

module "s3_bucket" {
  source = "../aws-modules/aws-storage/aws-s3-bucket"

  bucket_name          = "demo-dev-data-bucket"
  force_destroy        = false
  bucket_prefix        = null
  versioning_enabled   = true
  mfa_delete           = "Disabled"
  enable_encryption    = true
  encryption_algorithm = "aws:kms"
  kms_key_id           = "alias/my-kms-key" # Use a real key or set to null if default

  tags = {
    Environment = "dev"
    Owner       = "devops"
    Project     = "data-platform"
  }

  grants = [] # Optional: list of grant objects

  logging_enabled       = false
  #logging_target_bucket = "my-logging-bucket"
  #logging_target_prefix = "dev-logs/"

  lifecycle_rules = [
    {
      id     = "archive-old-objects"
      status = "Enabled"

      transition = [
        {
          days          = 30
          storage_class = "GLACIER"
        }
      ]

      expiration = [
        {
          days = 365
        }
      ]

      prefix = ""
    }
  ]

  replication_enabled  = false
  replication_role_arn = null
  replication_rules    = []
}