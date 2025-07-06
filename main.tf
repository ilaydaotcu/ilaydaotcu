provider "aws" {
region = "us-east-1"
}

resource "aws_vpc" "main" {
cidr_block = "var.vpc_cdir"
instance_tenancy = "default"
tags = {
Name = "main"
  }
}

resource "aws_subnet" "web" {
  count = length(var.web_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.web_subnet_cidrs[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true #any EC2 launched in this subnet will automatically get a public IP

  tags = {
    Name = "web-subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "app" {   
count = length(var.app_subnet_cidrs)
vpc_id = aws_vpc.main.id
cidr_block = var.web_subnet_cidrs[count.index]
map_public_ip_on_launch = true
tags = {
Name = "app-subnet-${count.index + 1}" 
  }
}
resource "aws_subnet" "db" {
count = length(var.app_subnet_cidrs)
vpc_id = aws_vpc.main.id
cidr_block = var.db_subnet_cidrs[count.index]
map_public_ip_on_launch = true
tags = {
Name = "db-subnet-${count.index + 1}" 
  }
}

variable "web_subnet_cidrs" {
  description = "List of CIDRs for web/public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "app_subnet_cidrs" {
  description = "List of CIDRs for app/private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}   
variable "db_subnet_cidrs" {
  description = "List of CIDRs for database subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}               




variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""
}