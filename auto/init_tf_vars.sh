#!/usr/bin/env bash

printf "
variable \"zone\" {
    default=\"\"
}

locals {
    
    lans = {
        default = [\"192.168.10.0/24\"]
    }
    master_nodes = $MASTERS
    worker_nodes = $WORKERS
    ingress_nodes = $INGRESS
}

output \"master_external_ip_address\" {
    value = {for k, v in yandex_compute_instance.master_node: k => v.network_interface.0.nat_ip_address}
}

output \"worker_external_ip_address\" {
    value = {for k, v in yandex_compute_instance.worker_node: k => v.network_interface.0.nat_ip_address}
}

output \"ingress_external_ip_address\" {
    value = {for k, v in yandex_compute_instance.ingress_node: k => v.network_interface.0.nat_ip_address}
}

output \"master_local_ip_address\" {
    value = {for k, v in yandex_compute_instance.master_node: k => v.network_interface.0.ip_address}
}

output \"worker_local_ip_address\" {
    value = {for k, v in yandex_compute_instance.worker_node: k => v.network_interface.0.ip_address}
}

output \"ingress_local_ip_address\" {
    value = {for k, v in yandex_compute_instance.ingress_node: k => v.network_interface.0.ip_address}
}
"