resource "digitalocean_kubernetes_cluster" "ag" {
    name    = "ag"
    region  = "sfo2"
    # Grab the latest version slug from `doctl kubernetes options versions`
    version = "1.18.8-do.0"

    node_pool {
        name       = "worker-pool"
        size       = "s-1vcpu-2gb"
        node_count = 2
    }
}

output "cluster-id" {
    value = "${digitalocean_kubernetes_cluster.ag.id}"
}