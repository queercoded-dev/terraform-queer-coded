# ssh -nNT -L localhost:5000:/run/libvirt/libvirt-sock hetznerserver
libvirt_uri = "qemu+tcp://localhost:5000/system"

libvirt_external_interface = "enp34s0"

qc_vm_hostname   = "queercoded"
qc_vm_domain     = "queercoded.dev"
qc_vm_nameserver = "9.9.9.9"
qc_vm_mac        = "00:50:56:00:8F:E9"

qc_vm_ssh_pub_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG283FDeWWLpJ7USwlv9BaOJgQITWhQ92xZpCz/CQb51" # Queer Coded Key
