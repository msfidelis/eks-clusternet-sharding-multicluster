resource "aws_ssm_parameter" "cluster_url" {
  name  = format("/%s/clusternet/parent/api", var.cluster_name)
  type  = "String"
  value = aws_eks_cluster.main.endpoint
}