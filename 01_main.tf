# vi: set ts=2 sw=2 sts=0 et:
#
# - ドキュメント https://sacloud.github.io/terraform-provider-sakuracloud/
#
###############################################################################
# Data Source

# sakuracloud_archive - コピー元ディスク
# - https://sacloud.github.io/terraform-provider-sakuracloud/configuration/resources/data_resource/
data sakuracloud_archive "ubuntu" {
  os_type = "ubuntu" # Ubuntuの最新安定版パブリックアーカイブ
}

###############################################################################
provider sakuracloud {
    zone = "tk1a" # 東京第1ゾーン
}

###############################################################################
# 公開鍵の設定
# - https://sacloud.github.io/terraform-provider-sakuracloud/configuration/resources/ssh_key/
resource "sakuracloud_ssh_key" "setup_keypair" {
  name = "${var.key_name}"
  public_key = "${var.public_key}"
}

###############################################################################
# ディスクの設定
# - https://sacloud.github.io/terraform-provider-sakuracloud/configuration/resources/disk/
resource "sakuracloud_disk" "main_disk"{
  name = "main_disk"
  description = "Disk for main server"
  tags = ["admin"]
  zone = "tk1a"

  plan = "ssd"
  connector = "virtio"
  size = 20
  source_archive_id = "${data.sakuracloud_archive.ubuntu.id}"
  hostname = "main"
  ssh_key_ids = ["${sakuracloud_ssh_key.setup_keypair.id}"]
  password = ""
  disable_pw_auth = true
}

###############################################################################
# サーバの設定
# - https://sacloud.github.io/terraform-provider-sakuracloud/configuration/resources/server/
resource "sakuracloud_server" "main_server" {
  name = "main_server"
  description = "Main server"
  disks = ["${sakuracloud_disk.main_disk.id}"]
  tags = ["admin"]
  
  core = 1
  memory = 1
  nic = "shared"
  packet_filter_ids = ["${sakuracloud_packet_filter.Rules.id}"]

}

