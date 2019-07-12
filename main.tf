resource "linode_stackscript" "this" {
  label       = "deploy-wireguard"
  description = "Deploy wireguard"
  script      = file("${path.module}/assets/stackscript.sh")
  images      = var.image_ids
}

