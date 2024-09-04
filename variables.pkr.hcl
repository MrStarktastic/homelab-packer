variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "node" {
  default = "pve"
}

variable "template_description" {
  default = "Ubuntu Jammy"
}

variable "vm_id" {
  default = 900
}

variable "vm_name_prefix" {
  default = "ubuntu-22.04.04"
}

variable "iso_base_url" {
  default = "https://releases.ubuntu.com/jammy"
}

variable "iso_name" {
  default = "ubuntu-22.04.4-live-server-amd64.iso"
}

variable "scsi_controller" {
  default = "virtio-scsi-single"
}

variable "cpu_type" {
  default = "x86-64-v2-AES"
}

variable "cores" {
  default = 1
}

variable "memory" {
  default = 2048
}

variable "disk_storage_pool" {
  default = "vm-disk-2"
}

variable "network_adapter_bridge" {
  default = "vmbr0"
}

variable "builder_ssh_creds" {
  default = {
    username = "packer"
    password = "packer"
    # openssl passwd -6 -stdin <<< packer
    hashed_passwd = "$6$42m.MyMusfbLi5R9$pY1.FG8pBr/gsfo/r0NGa2RTL9DBgmjncLghQNNyr6ms99hhoubWd363vNwzSRvRZHXuVY795BHMX/R.a7wsn0"
  }
}
