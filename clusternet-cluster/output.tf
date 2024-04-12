# output "clusternet_url" {
#   value = aws_lb.clusternet.dns_name
# }

output "clusternet_iam" {
  value = aws_iam_role.clusternet.arn
}

output "clusternet_deployer_iam" {
  value = aws_iam_role.clusternet_deployer.arn
}