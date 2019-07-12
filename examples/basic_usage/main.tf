provider "aws" {
  region = "us-west-1"
}

#-------------------------------------------------------------------------------
# Create a subnet inside a VPC.
#-------------------------------------------------------------------------------
resource "aws_vpc" "the_vpc" {
  cidr_block           = "10.99.49.0/24"
  enable_dns_hostnames = true
}

resource "aws_subnet" "the_subnet" {
  vpc_id            = aws_vpc.the_vpc.id
  cidr_block        = "10.99.49.0/24"
  availability_zone = "us-west-1b"
}

#-------------------------------------------------------------------------------
# Set up external access and routing in the VPC.
#-------------------------------------------------------------------------------

# The internet gateway for the VPC
resource "aws_internet_gateway" "the_igw" {
  vpc_id = aws_vpc.the_vpc.id
}

# Default route table
resource "aws_default_route_table" "the_route_table" {
  default_route_table_id = aws_vpc.the_vpc.default_route_table_id
}

# Route all external traffic through the internet gateway
resource "aws_route" "route_external_traffic_through_internet_gateway" {
  route_table_id         = aws_default_route_table.the_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.the_igw.id
}


#-------------------------------------------------------------------------------
# Create a private Route53 zone.
#-------------------------------------------------------------------------------
resource "aws_route53_zone" "private_zone" {
  name = "cyber.dhs.gov"

  vpc {
    vpc_id = aws_vpc.the_vpc.id
  }
}

#-------------------------------------------------------------------------------
# Create a private Route53 reverse zone.
#-------------------------------------------------------------------------------
resource "aws_route53_zone" "private_reverse_zone" {
  name = "49.99.10.in-addr.arpa"

  vpc {
    vpc_id = aws_vpc.the_vpc.id
  }
}

#-------------------------------------------------------------------------------
# Create a data resource for the existing public Route53 zone.
#-------------------------------------------------------------------------------
data "aws_route53_zone" "public_zone" {
  name = "cyber.dhs.gov."
}

#-------------------------------------------------------------------------------
# Configure the example module.
#-------------------------------------------------------------------------------
module "ipa" {
  source = "../../"

  directory_service_pw    = "thepassword"
  admin_pw                = "thepassword"
  domain                  = "cal2.cyber.dhs.gov"
  hostname                = "ipa.cal2.cyber.dhs.gov"
  private_zone_id         = aws_route53_zone.private_zone.zone_id
  private_reverse_zone_id = aws_route53_zone.private_reverse_zone.zone_id
  public_zone_id          = data.aws_route53_zone.public_zone.zone_id
  realm                   = "CAL2.CYBER.DHS.GOV"
  subnet_id               = aws_subnet.the_subnet.id
  trusted_cidr_blocks = [
    "10.99.49.0/24",
    "108.31.3.53/32"
  ]
  associate_public_ip_address = true
  tags = {
    Testing = true
  }
}