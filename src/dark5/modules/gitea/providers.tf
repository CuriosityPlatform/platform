provider "helm" {
  kubernetes {
    config_path = "../.kube.yaml"
  }
}
