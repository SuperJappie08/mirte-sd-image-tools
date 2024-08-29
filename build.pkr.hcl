packer {
  required_plugins {
    arm-image = {
      version = ">= 0.2.11"
      source  = "github.com/arendjan/arm-image"
    }
        virtualbox = {
          version = "~> 1"
          source  = "github.com/hashicorp/virtualbox"
        }
  }
}

source "arm-image" "mirte_orangepizero2" {
  image_type = "armbian"
  iso_url = "https://surfdrive.surf.nl/files/index.php/s/Zoep7yE9GlX3o7m/download?path=%2F&files=Armbian_22.02.2_Orangepizero2_focal_legacy_4.9.255.img.xz"
  iso_checksum = "sha256:d2a6e59cfdb4a59fbc6f8d8b30d4fb8c4be89370e9644d46b22391ea8dff701d"
  output_filename = "./workdir/mirte_orangepizero2.img"
  target_image_size = 15*1024*1024*1024
  qemu_binary = "qemu-aarch64-static"
}

source "arm-image" "mirte_orangepizero" {
  image_type = "armbian"
  iso_url = "https://surfdrive.surf.nl/files/index.php/s/Zoep7yE9GlX3o7m/download?path=%2F&files=Armbian_21.02.3_Orangepizero_focal_current_5.10.21.img.xz"
  iso_checksum = "sha256:44ceec125779d67c1786b31f9338d9edf5b4f64324cc7be6cfa4a084c838a6ca"
  output_filename = "./workdir/mirte_orangepizero.img"
  target_image_size = 15*1024*1024*1024
}
source "arm-image" "mirte_orangepi3b" {
    image_type = "armbian"
  iso_url = "https://surfdrive.surf.nl/files/index.php/s/bRRFLjMNUkU9L78/download?path=Armbian-unofficial_23.11.0-trunk_Orangepi3b_focal_edge_6.6.2.img.xz"
  iso_checksum = "sha256:fe8dac9fe9d5697377ef230de1df94d99b9740b104f0042caded44f904f5d5a4"
  #   iso_url = "https://surfdrive.surf.nl/files/index.php/s/Zoep7yE9GlX3o7m/download?path=%2F&files=Armbian-unofficial_24.2.0-trunk_Orangepi3b_focal_legacy_5.10.160_msdos.img.xz"
  # iso_checksum = "sha256:376656dce00ff2e6404dd20110af4b1f0927b847c3c49d6a705dcf31789aaa34"
  output_filename = "./workdir/mirte_orangepi3b.img"
  target_image_size = 15*1024*1024*1024
  qemu_binary = "qemu-aarch64-static"
}

source "arm-image" "mirte_rpi4b" { # TODO: change to armbian image
  image_type = "raspberrypi"
  iso_url = "https://cdimage.ubuntu.com/releases/20.04.5/release/ubuntu-20.04.5-preinstalled-server-armhf+raspi.img.xz"
  iso_checksum = "sha256:065c41846ddf7a1c636a1aac5a7d49ebcee819b141f9d57fd586c5f84b9b7942"
  output_filename = "./workdir/mirte_rpi4b.img"
  target_image_size = 15*1024*1024*1024 # 15GB
}

source "virtualbox-ovf" "install_tests" {
  // guest_os_type = "Ubuntu"
  source_path = "https://mirte.arend-jan.com/files/test/Armbian_Focal_Uefi.ova"
  // iso_checksum = "none"
  checksum = "sha256:55e43e62639628be9013d1b60ea90d035dd1f02dd3ac14f0786940375f7ff094"
  ssh_username = "root"
  ssh_password = "1234"
  output_directory = "./workdir/vm"
  shutdown_command = "echo '1234' | sudo -S shutdown -P now"
  headless = true
}


build {
  sources = ["source.arm-image.mirte_orangepizero2", "source.arm-image.mirte_orangepizero",  "source.arm-image.mirte_orangepi3b", "source.arm-image.mirte_rpi4b", "source.virtualbox-ovf.install_tests"]
  provisioner "file" {
    source = "git_local"
    destination = "/usr/local/src/mirte"
  }
  provisioner "file" {
    source = "repos.yaml"
    destination = "/usr/local/src/mirte/"
  }
  provisioner "file" {
    source = "settings.sh"
    destination = "/usr/local/src/mirte/"
  }
  provisioner "file"  {
    source = "wheels"
    destination = "/usr/local/src/mirte/wheels/"
  }
  provisioner "file"  {
    source = "mirte_main_install.sh"
    destination = "/usr/local/src/mirte/"
  }
 provisioner "shell" {
    inline_shebang = "/bin/bash -e"
    inline = [
      "chmod +x /usr/local/src/mirte/mirte_main_install.sh",
      "export type=${source.name}",
      "echo $type",
      "mkdir /usr/local/src/mirte/build_system/",
      "sudo -E /usr/local/src/mirte/mirte_main_install.sh"
    ]
  }
  # provisioner "file" { # Provide the logs to the sd itself, doesn't work as tee deletes it and packer is missing it
  #   source = " logs/current_log.txt"
  #   destination = "/usr/local/src/mirte/build_system/"
  # }
  provisioner "file" { # provide the build script
    source = "build.pkr.hcl"
    destination = "/usr/local/src/mirte/build_system/"
  }
}