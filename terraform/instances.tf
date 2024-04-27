resource "yandex_compute_disk" "master_disk" {
  count = local.master_nodes
  name     = "master-disk-${count.index}"
  type     = "network-ssd"
  zone     = var.zone
  size     = 50
  image_id = data.yandex_compute_image.ubuntu.id
} 

resource "yandex_compute_disk" "worker_disk" {
  count = local.worker_nodes
  name     = "worker-disk-${count.index}"
  type     = "network-hdd"
  zone     = var.zone
  size     = 50
  image_id = data.yandex_compute_image.ubuntu.id
} 

resource "yandex_compute_disk" "ingress_disk" {
  count = local.ingress_nodes
  name     = "ingress-disk-${count.index}"
  type     = "network-hdd"
  zone     = var.zone
  size     = 50
  image_id = data.yandex_compute_image.ubuntu.id
} 

resource "yandex_compute_instance" "master_node" {
  count = local.master_nodes
  name = "master-${count.index}"
  platform_id = "standard-v2"
  zone = var.zone
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    disk_id = element(yandex_compute_disk.master_disk.*.id, count.index)
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.cluster_subnet.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_compute_instance" "worker_node" {
  count = local.worker_nodes
  name = "worker-0${count.index}"
  platform_id = "standard-v2"
  zone = var.zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    disk_id = element(yandex_compute_disk.worker_disk.*.id, count.index)
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.cluster_subnet.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_compute_instance" "ingress_node" {
  count = local.ingress_nodes
  name = "ingress-0${count.index}"
  platform_id = "standard-v2"
  zone = var.zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    disk_id = element(yandex_compute_disk.ingress_disk.*.id, count.index)
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.cluster_subnet.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}