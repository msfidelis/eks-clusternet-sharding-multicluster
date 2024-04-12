resource "helm_release" "clusternet_controller_manager" {
  name             = "clusternet-controller-manager"
  repository       = "https://clusternet.github.io/charts"
  chart            = "clusternet-controller-manager"
  namespace        = "clusternet-system"
  create_namespace = true

  depends_on = [
    aws_eks_cluster.main,
    kubernetes_config_map.aws-auth,
    aws_eks_node_group.cluster,
  ]
}

resource "helm_release" "clusternet_hub" {
  name             = "clusternet-hub"
  repository       = "https://clusternet.github.io/charts"
  chart            = "clusternet-hub"
  namespace        = "clusternet-system"
  create_namespace = true

  set {
    name  = "anonymousAuthSupported"
    value = "false"
  }

  depends_on = [
    aws_eks_cluster.main,
    kubernetes_config_map.aws-auth,
    aws_eks_node_group.cluster,
  ]
}

resource "helm_release" "clusternet_scheduler" {
  name             = "clusternet-scheduler"
  repository       = "https://clusternet.github.io/charts"
  chart            = "clusternet-scheduler"
  namespace        = "clusternet-system"
  create_namespace = true

  depends_on = [
    aws_eks_cluster.main,
    kubernetes_config_map.aws-auth,
    aws_eks_node_group.cluster,
  ]
}

resource "kubectl_manifest" "secret" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  # Name MUST be of form "bootstrap-token-<token id>"
  name: bootstrap-token-07401b
  namespace: clusternet-system

# Type MUST be 'bootstrap.kubernetes.io/token'
type: bootstrap.kubernetes.io/token
stringData:
  # Human readable description. Optional.
  description: "The bootstrap token used by clusternet cluster registration."

  # Token ID and secret. Required.
  token-id: 07401b
  token-secret: f395accd246ae52d


  # Allowed usages.
  usage-bootstrap-authentication: "true"
  usage-bootstrap-signing: "true"

  auth-extra-groups: system:bootstrappers:clusternet:register-cluster-token

YAML

  depends_on = [
    aws_eks_cluster.main,
    kubernetes_config_map.aws-auth,
    aws_eks_node_group.cluster,
    helm_release.clusternet_hub
  ]

}