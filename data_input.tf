data "terraform_remote_state" "static" {
 backend     = "s3"

 config {
   bucket = "terraform-state-remote-storages"
   key    = "terraform/dev"
   region = "us-east-1"
 }
}


 vpc_id  = "${data.terraform_remote_state.static.vpc_id}"
 aws_subnet  = "${data.terraform_remote_state.static.aws_subnet}"
 aws_internet_gateway  = "${data.terraform_remote_state.static.aws_internet_gateway}"
 aws_route_table  = "${data.terraform_remote_state.static.aws_route_table}"
 aws_route_table_association  = "${data.terraform_remote_state.static.aws_route_table_association}"



