output "clusternet_rollouts_url" {
  value = format("http://%s", aws_lb.argo.dns_name)
}