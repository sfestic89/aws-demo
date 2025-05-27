module "security_groups" {
  source = "../../aws-modules/aws-networking/aws-security-groups"

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

    db-sg = {
      description = "Allow MySQL from web-sg"
      vpc_id      = module.vpc.vpc_ids["dev"]
      ingress = [
        {
          from_port       = 3306
          to_port         = 3306
          protocol        = "tcp"
          security_groups = ["${module.security_groups.security_group_ids["web-sg"]}"]
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
