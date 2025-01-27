# main.tf
output "vpc" {
  description = "Full VPC submodule output"
  value       = merge(aws_vpc.this, { vpc_region = data.aws_region.current.name })
}

# natgw.tf
output "aws_eip" {
  value = (can(aws_eip.this)) ? {
    for k, v in aws_eip.this : v.id => {
      public_ip = v.public_ip
    }
  } : null
}

output "aws_nat_gateway" {
  value = (can(aws_nat_gateway.this)) ? {
    for k, v in aws_nat_gateway.this : v.id => {
      public_ip = v.public_ip
      eip_alloc = v.allocation_id
    }
  } : null
}

# private.tf
output "aws_subnet_private_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "aws_subnet_private" {
  value = aws_subnet.private
}

output "aws_route_table_private" {
  value = aws_route_table.private
}

output "aws_route_table_association_private" {
  value = aws_route_table_association.private
}

output "aws_route_table_ids" {
  value = [for k, v in aws_route_table.private : v.id]
}

# public.tf
output "aws_subnet_public_ids" {
  value = [for subnet in try(aws_subnet.public, []) : subnet.id]
}

output "aws_subnet_public" {
  value = try(aws_subnet.public, null)
}

output "aws_route_table_public" {
  value = aws_route_table.public
}

output "aws_route_table_association_public" {
  value = try(aws_route_table_association.public, null)
}

output "aws_internet_gateway" {
  value = aws_internet_gateway.this
}

# firewall.tf
output "aws_subnet_firewall_ids" {
  value = [for subnet in aws_subnet.firewall : subnet.id]
}

output "aws_subnet_firewall" {
  value = aws_subnet.firewall
}

output "aws_route_table_firewall" {
  value = aws_route_table.firewall
}

output "aws_route_table_association_firewall" {
  value = aws_route_table_association.firewall
}

output "aws_firewall_route_table_ids" {
  value = [for k, v in aws_route_table.firewall : v.id]
}
