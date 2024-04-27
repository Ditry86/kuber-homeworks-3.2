resource "yandex_vpc_network" "cluster_vpc" {
}

resource "yandex_vpc_subnet" "cluster_subnet" {
  name           = "main-cluster-lan"
  zone           = var.zone
  network_id     = yandex_vpc_network.cluster_vpc.id
  v4_cidr_blocks = local.lans.default
}