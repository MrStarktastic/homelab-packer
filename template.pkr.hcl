packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

locals {
  vm_name = "${var.vm_name_prefix}-${uuidv4()}"
}

source "proxmox-iso" "ubuntu" {
  proxmox_url = var.proxmox_api_url
  username    = var.proxmox_api_token_id
  token       = var.proxmox_api_token_secret

  node                 = var.node
  template_description = var.template_description
  vm_id                = var.vm_id
  vm_name              = local.vm_name

  iso_url          = "${var.iso_base_url}/${var.iso_name}"
  iso_checksum     = "file:${var.iso_base_url}/SHA256SUMS"
  iso_storage_pool = "local"
  unmount_iso      = true

  qemu_agent = true

  scsi_controller = var.scsi_controller

  cpu_type = var.cpu_type
  cores    = var.cores
  memory   = var.memory

  disks {
    type         = "virtio"
    format       = "qcow2"
    disk_size    = "8G"
    storage_pool = var.disk_storage_pool
  }

  network_adapters {
    model  = "virtio"
    bridge = var.network_adapter_bridge
  }

  cloud_init              = true
  cloud_init_storage_pool = var.disk_storage_pool
  http_content = {
    "/meta-data" = file("${path.root}/http/meta-data")
    "/user-data" = templatefile(
      "${path.root}/http/user-data",
      {
        username      = var.builder_ssh_creds.username,
        hashed_passwd = var.builder_ssh_creds.hashed_passwd
      }
    )
  }

  boot_wait = "5s"
  boot      = "c"
  boot_command = [
    "c",
    "linux /casper/vmlinuz autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
    "<enter><wait5>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot<enter>"
  ]

  ssh_username = var.builder_ssh_creds.username
  ssh_password = var.builder_ssh_creds.password
  ssh_timeout  = "20m"
}

build {
  name    = "ubuntu"
  sources = ["source.proxmox-iso.ubuntu"]

  provisioner "shell" {
    expect_disconnect = true
    execute_command   = "{{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts = [
      "scripts/wait_cloud_init.sh",
      "scripts/update.sh",
      "scripts/cleanup.sh"
    ]
  }

  provisioner "shell" {
    skip_clean      = true
    execute_command = "chmod +x {{ .Path }}; sudo env {{ .Vars }} {{ .Path }}; rm -f {{ .Path }}"
    env = {
      CI_USER = var.builder_ssh_creds.username
    }
    script = "scripts/delete_cloud_init_user.sh"
  }

  post-processor "manifest" {
    custom_data = {
      vm_name = local.vm_name
    }
  }
}
