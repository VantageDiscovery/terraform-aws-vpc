# VPC
variable "vpc_cidr" {
  description = "string: cidr for the vpc"
  type        = string
  default     = null
}

variable "region_config" {
  description = "full region config"
  type = object({
    enabled = bool
    short   = string
    az_ids  = list(string)
  })
}

variable "enable_dns_hostnames" {
  description = "Whether to enable DNS Hostnames"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Whether to enable DNS Support"
  type        = bool
  default     = true
}

variable "enable_network_address_usage_metrics" {
  description = "Whether to enable Network Address Usage Metrics"
  type        = bool
  default     = true
}

variable "enable_tgw" {
  description = "Whether to enable Transit Gateway Networking"
  type        = bool
  default     = false
}

variable "tgw_static_routes" {
  description = "Static Routes to send via the Transit Gateway from the VPC"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "tgw_id" {
  description = "TGW ID"
  type        = string
  default     = null
}

variable "tgw_enable_dns_support" {
  description = "Whether to enable DNS Support for the Transit Gateway Attachment"
  type        = bool
  default     = true
}

variable "tgw_enable_ipv6_support" {
  description = "Whether to enable IPv6 Support for the Transit Gateway Attachment"
  type        = bool
  default     = false
}

variable "tgw_enable_multicast_support" {
  description = "Whether to enable Multicast Support for the Transit Gateway Attachment"
  type        = bool
  default     = false
}

variable "tgw_enable_appliance_mode_support" {
  description = "Whether to enable Appliance Mode Support for the Transit Gateway Attachment"
  type        = bool
  default     = true
}

variable "tgw_association_table" {
  description = "The TGW Route Table to associate the VPC with"
  type        = string
  default     = null
}

variable "tgw_propagation_tables" {
  description = "The TGW Route Tables to propagate routes from the VPC"
  type        = list(string)
  default     = []
}

# SUBNETS
variable "public_subnets_cidrs" {
  description = "list of strings: declare cidrs for the public subnets"
  type        = list(string)
  default     = []
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route tables"
  type        = map(string)
  default     = {}
}

variable "private_subnets_cidrs" {
  description = "list of strings: declare cidrs for the private subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route tables"
  type        = map(string)
  default     = {}
}

variable "tgw_subnets_cidrs" {
  description = "list of strings: declare cidrs for the transit gateway subnets"
  type        = list(string)
  default     = []
}

variable "tgw_subnet_tags" {
  description = "Additional tags for the tgw subnets"
  type        = map(string)
  default     = {}
}

variable "tgw_route_table_tags" {
  description = "Additional tags for the tgw route tables"
  type        = map(string)
  default     = {}
}

variable "firewall_subnets_cidrs" {
  description = "list of strings: declare cidrs for the firewall subnets"
  type        = list(string)
  default     = []
}

variable "firewall_subnet_tags" {
  description = "Additional tags for the firewall subnets"
  type        = map(string)
  default     = {}
}

variable "firewall_route_table_tags" {
  description = "Additional tags for the firewall route tables"
  type        = map(string)
  default     = {}
}

variable "enable_anf" {
  description = "Whether to enable the components needed for using AWS Network Firewall (Default: false)"
  type        = bool
  default     = false
}

variable "enable_ipam" {
  description = "Whether to enable the AWS VPC IPAM or not in CIDR selection (Default: false)"
  type        = bool
  default     = false
}

#variable "ipam_pool" {
#description = "AWS IPAM Pool Name"
#type        = string
#default     = null
#}

#variable "cidr_mask_length" {
#description = "Mask length to yank from IPAM pool"
#type        = number
#default     = 21
#}

# VPC PEERS
variable "vpc_peers" {
  description = "List of maps defining the VPCs to peer with"
  type = list(map(object({
    vpc_id       = string
    account_id   = string
    region       = string
    cidr         = string
    route_tables = list(string)
  })))
  default = []
}

# IPv6
variable "enable_ipv6" {
  description = "Bool to enable IPv6 in the VPC"
  type        = bool
  default     = false
}

#variable "ipv6_cidr" {
#description = "Explicit IPv6 CIDR to use for the VPC (don't set when using ipam and var.ipv6_netmask_length"
#type        = string
#default     = null
#}

variable "ipv6_ipam_pool_id" {
  description = "IPAM Pool ID to use for IPv6 subnet assignment"
  type        = string
  default     = null
}

variable "ipv6_netmask_length" {
  description = "IPv6 Netmask Length to use when getting a v6 assignment from IPAM"
  type        = number
  default     = 56
}

#variable "ipam_public_scope_id" {
#description = "IPAM Public Scope to use for IPv6 subnet assignment"
#type        = string
#default     = null
#}

variable "public_subnet_assign_ipv6_address_on_creation" {
  description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address."
  type        = bool
  default     = true
}

variable "public_subnet_enable_dns64" {
  description = "Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations."
  type        = bool
  default     = true
}

variable "public_subnet_enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records."
  type        = bool
  default     = false
}

variable "public_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records"
  type        = bool
  default     = false
}

variable "private_subnet_assign_ipv6_address_on_creation" {
  description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address."
  type        = bool
  default     = true
}

variable "private_subnet_enable_dns64" {
  description = "Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations."
  type        = bool
  default     = true
}

variable "private_subnet_enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records."
  type        = bool
  default     = false
}

variable "private_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records"
  type        = bool
  default     = false
}

variable "tgw_subnet_assign_ipv6_address_on_creation" {
  description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address."
  type        = bool
  default     = true
}

variable "tgw_subnet_enable_dns64" {
  description = "Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations."
  type        = bool
  default     = true
}

variable "tgw_subnet_enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records."
  type        = bool
  default     = false
}

variable "tgw_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records"
  type        = bool
  default     = false
}

variable "firewall_subnet_assign_ipv6_address_on_creation" {
  description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address."
  type        = bool
  default     = true
}

variable "firewall_subnet_enable_dns64" {
  description = "Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations."
  type        = bool
  default     = true
}

variable "firewall_subnet_enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records."
  type        = bool
  default     = false
}

variable "firewall_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records"
  type        = bool
  default     = false
}

################################################################################
# Flow Log
################################################################################

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "vpc_flow_log_iam_role_name" {
  description = "Name to use on the VPC Flow Log IAM role created"
  type        = string
  default     = "vpc-flow-log-role"
}

variable "vpc_flow_log_iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`vpc_flow_log_iam_role_name_name`) is used as a prefix"
  type        = bool
  default     = true
}


variable "vpc_flow_log_permissions_boundary" {
  description = "The ARN of the Permissions Boundary for the VPC Flow Log IAM Role"
  type        = string
  default     = null
}

variable "vpc_flow_log_iam_policy_name" {
  description = "Name of the IAM policy"
  type        = string
  default     = "vpc-flow-log-to-cloudwatch"
}

variable "vpc_flow_log_iam_policy_use_name_prefix" {
  description = "Determines whether the name of the IAM policy (`vpc_flow_log_iam_policy_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "flow_log_max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds"
  type        = number
  default     = 600
}

variable "flow_log_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL"
  type        = string
  default     = "ALL"
}

variable "flow_log_destination_type" {
  description = "Type of flow log destination. Can be s3, kinesis-data-firehose or cloud-watch-logs"
  type        = string
  default     = "cloud-watch-logs"
}

variable "flow_log_log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear"
  type        = string
  default     = null
}

variable "flow_log_destination_arn" {
  description = "The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create_flow_log_cloudwatch_log_group is set to false this argument must be provided"
  type        = string
  default     = ""
}

variable "flow_log_deliver_cross_account_role" {
  description = "(Optional) ARN of the IAM role that allows Amazon EC2 to publish flow logs across accounts."
  type        = string
  default     = null
}

variable "flow_log_file_format" {
  description = "(Optional) The format for the flow log. Valid values: `plain-text`, `parquet`"
  type        = string
  default     = null
}

variable "flow_log_hive_compatible_partitions" {
  description = "(Optional) Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3"
  type        = bool
  default     = false
}

variable "flow_log_per_hour_partition" {
  description = "(Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries"
  type        = bool
  default     = false
}

variable "vpc_flow_log_tags" {
  description = "Additional tags for the VPC Flow Logs"
  type        = map(string)
  default     = {}
}

################################################################################
# Flow Log CloudWatch
################################################################################

variable "create_flow_log_cloudwatch_log_group" {
  description = "Whether to create CloudWatch log group for VPC Flow Logs"
  type        = bool
  default     = false
}

variable "create_flow_log_cloudwatch_iam_role" {
  description = "Whether to create IAM role for VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow_log_destination_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided"
  type        = string
  default     = ""
}

variable "flow_log_cloudwatch_log_group_name_prefix" {
  description = "Specifies the name prefix of CloudWatch Log Group for VPC flow logs"
  type        = string
  default     = "/aws/vpc-flow-log/"
}

variable "flow_log_cloudwatch_log_group_name_suffix" {
  description = "Specifies the name suffix of CloudWatch Log Group for VPC flow logs"
  type        = string
  default     = ""
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group for VPC flow logs"
  type        = number
  default     = null
}

variable "flow_log_cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data for VPC flow logs"
  type        = string
  default     = null
}

variable "flow_log_cloudwatch_log_group_skip_destroy" {
  description = " Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state"
  type        = bool
  default     = false
}

variable "flow_log_cloudwatch_log_group_class" {
  description = "Specified the log class of the log group. Possible values are: STANDARD or INFREQUENT_ACCESS"
  type        = string
  default     = null
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}
