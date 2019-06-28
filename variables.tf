# Variables Configuration
variable "aws_access_key" {}
variable "aws_secret_key" {}

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

data "terraform_remote_state" "static" {
 backend     = "s3"

 config {
   bucket = "terraform-state-remote-storages"
   key    = "terraform/dev"
   region = "us-east-1"
 }
}

module "app" {
 source  = "modules/blue-green"
 name    = "app"
 vpc_id  = "${data.terraform_remote_state.static.vpc_id}"
 aws_subnet  = "${data.terraform_remote_state.static.aws_subnet}"
 aws_internet_gateway  = "${data.terraform_remote_state.static.aws_internet_gateway}"
 aws_route_table  = "${data.terraform_remote_state.static.aws_route_table}"
 aws_route_table_association  = "${data.terraform_remote_state.static.aws_route_table_association}"
}





