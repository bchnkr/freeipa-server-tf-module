# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "domain" {
  type        = string
  description = "The domain for the IPA server (e.g. example.com)."
}

variable "hostname" {
  type        = string
  description = "The hostname of the IPA server (e.g. ipa.example.com)."
}

variable "ip" {
  type        = string
  description = "The IP address to assign the IPA server (e.g. 10.10.10.4).  Note that the IP address must be contained inside the CIDR block corresponding to subnet-id, and AWS reserves the first four and very last IP addresses.  We have to assign an IP in order to break the dependency of DNS record resources on the corresponding EC2 resources; otherwise, it is impossible to update the IPA servers one by one as is required when a new AMI is created."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the AWS subnet into which to deploy the IPA server (e.g. subnet-0123456789abcdef0)."
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults, or they are only used in
# certain cases.
# ------------------------------------------------------------------------------

variable "ami_owner_account_id" {
  type        = string
  description = "The ID of the AWS account that owns the FreeIPA server AMI, or \"self\" if the AMI is owned by the same account as the provisioner."
  default     = "self"
}

variable "aws_instance_type" {
  type        = string
  description = "The AWS instance type to deploy (e.g. t3.medium).  Two gigabytes of RAM is given as a minimum requirement for FreeIPA, but I have had intermittent problems when creating t3.small replicas."
  default     = "t3.medium"
}

variable "realm" {
  type        = string
  description = "The realm for the IPA server (e.g. EXAMPLE.COM).  Only used if this IPA server IS NOT intended to be a replica."
  default     = "EXAMPLE.COM"
}

variable "security_group_ids" {
  type        = list(string)
  description = "A list of IDs corresponding to security groups to which the server should belong (e.g. [\"sg-51530134\", \"sg-51530245\"]).  Note that these security groups must exist in the same VPC as the server."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created."
  default     = {}
}
