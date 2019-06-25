# Variables Configuration

variable "cluster-name" {
  default     = "DOTS_cluster"
  type        = "string"
  description = "The name of EKS Cluster"
}

variable "aws-region" {
  default     = "us-east-1"
  type        = "string"
  description = "The AWS Region to deploy EKS"
}

variable "k8s-version" {
  default     = "1.11"
  type        = "string"
  description = "K8s version"
}

variable "vpc-subnet-cidr" {
  default     = "10.0.0.0/16"
  type        = "string"
  description = "The VPC Subnet CIDR"
}

variable "node-instance-type" {
  default     = "t2.micro"
  type        = "string"
  description = "Worker Node EC2 instance type"
}

variable "desired-capacity" {
  default     = 2
  type        = "string"
  description = "Autoscaling Desired node capacity"
}

variable "max-size" {
  default     = 5
  type        = "string"
  description = "Autoscaling maximum node capacity"
}

variable "min-size" {
  default     = 1
  type        = "string"
  description = "Autoscaling Minimum node capacity"
}

variable "aws_vpc" {
  default     = "vpc-07555e2e264da3d32"
  type        = "string"
  description = "VPC"
}

variable "aws_subnet" {
  default     = "subnet-08840e2d912e51114"
  type        = "string"
  description = "subnet"
}

variable "aws_internet_gateway" {
  default     = "igw-0b06d9c720dbbaa4f"
  type        = "string"
  description = "internet gateway"
}

variable "aws_route_table" {
  default     = "rtb-0d666a4f9da483180"
  type        = "string"
  description = "route table"
}

variable "aws_route_table_association" {
  default     = "rtbassoc-08ed38f552c26b2f2"
  type        = "route table association"
  description = "subnet"
}
