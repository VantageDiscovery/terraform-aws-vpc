data "aws_region" "current" {}

data "aws_vpc_ipam_pool" "this" {
  filter {
    name   = "description"
    values = ["*${var.ipam_pool}*"]
  }

  filter {
    name   = "address-family"
    values = ["ipv4"]
  }
}

# Preview next CIDR from pool
data "aws_vpc_ipam_preview_next_cidr" "this" {
  ipam_pool_id   = data.aws_vpc_ipam_pool.this.id
  netmask_length = var.cidr_mask_length
}

data "external" "subnet_calculator" {
  program = ["python3", "${path.module}/subnet.py"]

  query = {
    base_cidr = data.aws_vpc_ipam_preview_next_cidr.this.cidr
    num_azs   = length(var.region_config.az_ids)
  }
}

locals {
  private_subnets  = split(",", data.external.subnet_calculator.result["private_subnets"])
  firewall_subnets = split(",", data.external.subnet_calculator.result["firewall_subnets"])
  public_subnets   = split(",", data.external.subnet_calculator.result["public_subnets"])
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1.0"

  # vpc
  cidr                          = data.aws_vpc_ipam_preview_next_cidr.this.cidr
  name                          = var.vpc_name
  instance_tenancy              = "default"
  enable_dns_hostnames          = true
  manage_default_security_group = true
  manage_default_route_table    = true
  manage_default_network_acl    = true
}

# VPC Peering with defined VPCs
resource "aws_vpc_peering_connection" "this" {
  for_each = { for vpc in var.vpc_peers : vpc.vpc_id => vpc }

  vpc_id        = module.vpc.vpc_id
  peer_vpc_id   = each.value.vpc_id
  peer_owner_id = each.value.account_id
  peer_region   = each.value.region
  auto_accept   = false
}

resource "aws_vpc_peering_connection_accepter" "this" {
  for_each = aws_vpc_peering_connection.this

  vpc_peering_connection_id = each.value.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "requester" {
  for_each = aws_vpc_peering_connection_accepter.this

  # As options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  vpc_peering_connection_id = each.value.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  for_each = aws_vpc_peering_connection_accepter.this

  vpc_peering_connection_id = each.value.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

# Create a map of destination VPCs, Peering Connection IDs, and Private Route Tables
locals {
  peering_map = flatten([
    for rt in aws_route_table.private : [
      for vpc in concat(var.network_vpc_peers, var.vpc_peers) : {
        route_table_id = rt.id
        peer_cidr      = vpc.cidr
        peering_id = try(aws_vpc_peering_connection.this[vpc.vpc_id].id, null)
      }
    ]
  ])

  return_route_map = merge([
    for vpc in concat(var.network_vpc_peers, var.vpc_peers) : {
      for rt in vpc.route_tables : rt => {
        region = vpc.region
        peering_id = try(aws_vpc_peering_connection.this[vpc.vpc_id].id, null)
      }
    }
  ]...)
}

resource "aws_route" "vpc_peering" {
  for_each = { for route in local.peering_map : "${route.route_table_id}_${route.peering_id}" => route }

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = each.value.peer_cidr
  vpc_peering_connection_id = each.value.peering_id
}
