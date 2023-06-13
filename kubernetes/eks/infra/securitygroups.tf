resource "aws_security_group" "node_remote" {
  name   = "${var.cluster_name}-node_remote"
  vpc_id = var.vpc_id

  tags = local.tags
}
