# vi: set ts=2 sw=2 sts=0 et:

# 変数
# - 変数ファイルは terraform.tfvars などで別ファイルに定義しても良い

# key_pair
variable "key_name" {
  default = "mapk0y@kona"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjceESBS7SuWx5+eu10lxoOv2k0SlrghIJY6cfGIkGbB5anNXORsYvOZH96NtwXvHy7d3TOCO2Iqb35k0K/GvPl1yPCyi1MQ3ZlBfApFWf8UDaEX9gcqhf3/rbPJVVpdZtu3owqdP1dAT6KJ2tgF0svnAcL/SA7IvK/qrmzjeUPUe2qmmODZmseQl/aOtqD1Q3q+TaG8sRF6ZUKVadyldVlcn+ohGSBUAaCcUxMgaj6GbvF8w5XE+vLRfS1wqUiFAweYgpYhbK/6p764uo2dmFZY4Dk42y321KKCvM11waYPQA4gWjSvV+WCjXGtnO1QNE7sGEuK9Kbn9YCJrB2Cwj mapk0y@kona"
}
