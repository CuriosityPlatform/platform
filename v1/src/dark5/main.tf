terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "ssh://microuser@microuser-dark5.local:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

resource "docker_image" "k3s" {
  name         = "rancher/k3s:v1.31.1-k3s1"
  keep_locally = true
}

resource "docker_image" "registry" {
  name         = "registry:2.8.3"
  keep_locally = true
}

resource "docker_volume" "k3s-server" {}

resource "docker_container" "k3s-server" {
  image = docker_image.k3s.image_id
  name  = "k3s-server"

  command = ["server", "--tls-san", "microuser-DARK5", "--tls-san", "microuser-DARK5.local"]
  env = [
    "K3S_KUBECONFIG_OUTPUT=/output/kubeconfig.yaml",
    "K3S_KUBECONFIG_MODE=666",
  ]

  volumes {
    volume_name    = docker_volume.k3s-server.name
    container_path = "/var/lib/rancher/k3s"
  }

  # Ports
  network_mode = "host"

  # Kubernetes API Server
  ports {
    internal = 6443
    external = 6443
  }
  # Ingress controller port 80
  ports {
    internal = 80
    external = 80
  }
  # Ingress controller port 443
  ports {
    internal = 443
    external = 443
  }

  # Machine config
  privileged = true
  tmpfs = {
    "/run"     = "",
    "/var/run" = "",
  }
  ulimit {
    name = "nproc"
    hard = 65535
    soft = 65535
  }
  ulimit {
    name = "nofile"
    hard = 65535
    soft = 65535
  }
  restart = "on-failure"
}

resource "docker_container" "registry" {
  image = docker_image.registry.image_id
  name  = "registry"

  network_mode = "host"

  ports {
    internal = 5000
    external = 5000
  }
}
