# tgw subnets
resource "aws_subnet" "tgw" {
  for_each = { for k, v in local.tgw_subnets : k => v }

  vpc_id               = aws_vpc.this.id
  cidr_block           = local.tgw_subnets[each.key]
  availability_zone_id = var.region_config.az_ids[each.key]

  assign_ipv6_address_on_creation                = var.enable_ipv6 && var.tgw_subnet_assign_ipv6_address_on_creation
  enable_dns64                                   = var.enable_ipv6 && var.tgw_subnet_enable_dns64
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.tgw_subnet_enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch    = var.tgw_subnet_enable_resource_name_dns_a_record_on_launch
  # each.key+3 is a result of planned space for up to 3x private, 3x firewall, 3x tgw, and 3x public subnets in that order
  ipv6_cidr_block = var.enable_ipv6 && length(local.tgw_subnets) > 0 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, each.key + 6) : null
  # Not going to support ipv6 only subnets for now
  ipv6_native = false

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-${var.region_config.az_ids[each.key]}-tgw-subnet",
      component = "subnet"
    },
    var.tgw_subnet_tags
  )
}

# route table
resource "aws_route_table" "tgw" {
  for_each = { for k, v in var.region_config.az_ids : k => v }

  vpc_id = aws_vpc.this.id

  tags = merge(
    module.this.tags,
    {
      Name      = "${var.stage != null ? "${var.stage}-" : ""}${var.name}-${each.value}-tgw-rt"
      component = "rt"
    },
    var.tgw_route_table_tags
  )
}
# route table tgw subnet association
resource "aws_route_table_association" "tgw" {
  for_each = { for k, v in local.tgw_subnets : k => v }

  subnet_id      = aws_subnet.tgw[each.key].id
  route_table_id = aws_route_table.tgw[each.key].id
}

# tgw association
locals {
  vpc_route_tables = concat(try(values(aws_route_table.private)[*].id, []), try([aws_route_table.public.id], []))

  vpc_tgw_routes = var.tgw_id == null ? {} : merge([
    for cidr in var.tgw_static_routes : {
      for i, table in local.vpc_route_tables : "${cidr}-${i}" => {
        destination_cidr_block = cidr
        route_table_id         = table
      }
    }
  ]...)

  tgw_association_subnets = (length(local.tgw_subnets) > 0) ? try(values(aws_subnet.tgw)[*].id, []) : slice(try(values(aws_subnet.private)[*].id, []), 0, length(var.region_config.az_ids))
}

module "tgw" {
  #source = "git@github.com:vantagediscovery/terraform-aws-transit-gateway//modules/tgw_vpc_attachments?ref=0.2.0"
  source = "/Users/loganbest/code/terraform-aws-transit-gateway//modules/tgw_vpc_attachments"

  count = (var.enable_tgw) ? 1 : 0

  vpc_id   = aws_vpc.this.id
  vpc_name = aws_vpc.this.tags["Name"]

  tgw_association_subnets = local.tgw_association_subnets
  tgw_id                  = var.tgw_id

  enable_dns_support            = var.tgw_enable_dns_support
  enable_ipv6_support           = var.tgw_enable_ipv6_support
  enable_appliance_mode_support = var.tgw_enable_appliance_mode_support

  tgw_association_table  = var.tgw_association_table
  tgw_propagation_tables = var.tgw_propagation_tables

  providers = {
    aws             = aws
    aws.netsvc      = aws.netsvc
    aws.netsvc_use2 = aws.netsvc_use2
  }

  tags = merge(
    module.this.tags
  )
}

resource "aws_route" "to_tgw" {
  for_each = { for k, v in local.vpc_tgw_routes : k => v if var.enable_tgw }

  route_table_id         = each.value.route_table_id
  transit_gateway_id     = var.tgw_id
  destination_cidr_block = each.value.destination_cidr_block
}
