# vi: set ts=2 sw=2 sts=0 et:

output "main_server" {
  value = "${sakuracloud_server.main_server.ipaddress}"
}
