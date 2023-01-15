resource "libvirt_volume" "opensuse_microos" {
  name   = "opensuse_microos"
  pool   = "default"
  source = "https://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-OpenStack-Cloud.qcow2" # MicroOS cloud-init image
  format = "qcow2"
}

resource "libvirt_volume" "qc_vm_disk" {
  name           = "qc_vm_disk"
  pool           = "default"
  base_volume_id = libvirt_volume.opensuse_microos.id
  size           = "268435456000" // 250GB disk
}

data "template_file" "qc_vm_cloudinit" {
  template = file("${path.module}/cloudinit.tpl")
  vars = {
    hostname       = var.qc_vm_hostname
    domain         = var.qc_vm_domain
    ssh_public_key = var.qc_vm_ssh_pub_key
    nameserver     = var.qc_vm_nameserver
  }
}

resource "libvirt_cloudinit_disk" "qc_init" {
  name = "qc_init"
  pool = "default"

  user_data = data.template_file.qc_vm_cloudinit.rendered
}


resource "libvirt_domain" "qc_vm" {
  name   = "qc_vm"
  memory = "24576" // 24GB
  vcpu   = 4       // 4 cores

  cloudinit = libvirt_cloudinit_disk.qc_init.id // Attach cloud-init disk

  disk {
    volume_id = libvirt_volume.qc_vm_disk.id
  }

  network_interface {
    macvtap        = var.libvirt_external_interface
    hostname       = var.qc_vm_hostname
    wait_for_lease = false
    mac            = var.qc_vm_mac // Hetzner wants us to use a provided MAC address
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
  }

}
