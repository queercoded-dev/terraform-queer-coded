#cloud-config

# Cloud init configuration for openSUSE MicroOS.
# This file is managed by terraform and will be overwritten.
# https://en.opensuse.org/Portal:MicroOS/cloud-init#user-data

hostname: ${hostname}
fqdn: ${hostname}.${domain}

ssh_pwauth: True
ssh_deletekeys: False
ssh_authorized_keys:
  - "${ssh_public_key}"

disable_root: False
chpasswd:
  list: |
    root:linux
  expire: False

manage_resolv_conf: true
resolv_conf:
  nameservers: ["${nameserver}"]
