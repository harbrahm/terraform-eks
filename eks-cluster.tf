# EKS Cluster Resources

terraform {
  backend "s3" {
    bucket  = "terraform-state-remote-storages"
    region  = "us-east-1"
    key     = "terraform/dev/terraformeks.tfstate"
    encrypt = true    
    workspace_key_prefix = ""
  }
}

data "terraform_remote_state" "static" {
 backend     = "s3"
 
 config {
   bucket = "terraform-state-remote-storages"
   key    = "${terraform.workspace}/terraform/dev/terraform.tfstate"
   region = "us-east-1"
  	workspace_key_prefix = ""

 }
   
  }





resource "aws_iam_role" "cluster" {
  name = "${var.cluster-name}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.cluster.name}"
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.cluster.name}"
}

resource "aws_security_group" "cluster" {
  name        = "${var.cluster-name}-eks-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${data.terraform_remote_state.static.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.cluster-name}-eks-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.cluster.id}"  
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = ["${local.workstation-external-cidr}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.cluster.id}"
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "eks" {
  name     = "${var.cluster-name}"
  role_arn = "${aws_iam_role.cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.cluster.id}"]
    subnet_ids         = ["${data.terraform_remote_state.static.aws_subnet1},${data.terraform_remote_state.static.aws_subnet2},${data.terraform_remote_state.static.aws_subnet3},${data.terraform_remote_state.static.aws_subnet4}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy",
  ]
}
