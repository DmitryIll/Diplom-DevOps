provider "helm" {
  kubernetes {
  config_path = var.path_to_kubconfig
  }
}