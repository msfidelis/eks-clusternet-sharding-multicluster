resource "helm_release" "clusternet_agent" {
  name              = "clusternet-agent"
  repository        = "https://clusternet.github.io/charts"
  chart             = "clusternet-agent"
  namespace         = "clusternet-system"
  create_namespace  = true

#   set {
#     name  = "parentURL"
#     value = data.aws_ssm_parameter.parent_url.value
#   }

#   set {
#     name  = "registrationToken"
#     value = "PLEASE-CHANGE-ME" // Substitua com o valor real conforme necessário
#   }
}