さくらのクラウドを terraform で操作した時にある条件でエラーが出る件

## 条件

パケットフィルタのルールを削除した場合、細かな条件は未確認

## 再現方法


```console
$ docker-compose run --rm terraform apply
$ ln -snvf 02_packet_filter.tf.after 02_packet_filter.tf
$ docker-compose run --rm terraform plan
$ docker-compose run --rm terraform apply
```

#### パケットフィルタの差分

```diff
$ diff -U1 02_packet_filter.tf.before 02_packet_filter.tf.after
--- 02_packet_filter.tf.before  2017-07-12 01:19:07.754888809 +0900
+++ 02_packet_filter.tf.after   2017-07-12 14:09:01.635086577 +0900
@@ -35,8 +35,2 @@
   expressions = {
-    protocol = "fragment"
-    source_nw = "0.0.0.0/0"
-    allow = true
-    description = "Allow fragment from all"
-  }
-  expressions = {
     protocol = "ip"
```

#### 実行ログ

```console
$ docker-compose run --rm terraform apply
$ ln -snvf 02_packet_filter.tf.after 02_packet_filter.tf
'02_packet_filter.tf' -> '02_packet_filter.tf.after'
$ docker-compose run --rm terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

sakuracloud_packet_filter.Rules: Refreshing state... (ID: 112900885360)
sakuracloud_ssh_key.setup_keypair: Refreshing state... (ID: 112900885327)
data.sakuracloud_archive.ubuntu: Refreshing state...
sakuracloud_disk.main_disk: Refreshing state... (ID: 112900885329)
sakuracloud_server.main_server: Refreshing state... (ID: 112900885337)
The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

-/+ sakuracloud_packet_filter.Rules
    description:               "Sample Rules" => "Sample Rules"
    expressions.#:             "5" => "4"
    expressions.0.allow:       "true" => "true"
    expressions.0.description: "Allow return tcp packet from all" => "Allow return tcp packet from all"
    expressions.0.dest_port:   "32768-61000" => "32768-61000"
    expressions.0.protocol:    "tcp" => "tcp"
    expressions.0.source_nw:   "0.0.0.0/0" => "0.0.0.0/0"
    expressions.1.allow:       "true" => "true"
    expressions.1.description: "Allow return udp packet from all" => "Allow return udp packet from all"
    expressions.1.dest_port:   "32768-61000" => "32768-61000"
    expressions.1.protocol:    "udp" => "udp"
    expressions.1.source_nw:   "0.0.0.0/0" => "0.0.0.0/0"
    expressions.2.allow:       "true" => "true"
    expressions.2.description: "Allow icmp from all" => "Allow icmp from all"
    expressions.2.protocol:    "icmp" => "icmp"
    expressions.2.source_nw:   "0.0.0.0/0" => "0.0.0.0/0"
    expressions.3.allow:       "true" => "false"
    expressions.3.description: "Allow fragment from all" => "Deny from all"
    expressions.3.protocol:    "fragment" => "ip" (forces new resource)
    expressions.3.source_nw:   "0.0.0.0/0" => "0.0.0.0/0"
    expressions.4.allow:       "false" => "true"
    expressions.4.description: "Deny from all" => ""
    expressions.4.protocol:    "ip" => "" (forces new resource)
    expressions.4.source_nw:   "0.0.0.0/0" => ""
    name:                      "Rules" => "Rules"
    zone:                      "tk1a" => "<computed>"

~ sakuracloud_server.main_server
    packet_filter_ids.#: "1" => "<computed>"


Plan: 1 to add, 1 to change, 1 to destroy.
$ docker-compose run --rm terraform apply
sakuracloud_ssh_key.setup_keypair: Refreshing state... (ID: 112900885327)
sakuracloud_packet_filter.Rules: Refreshing state... (ID: 112900885360)
data.sakuracloud_archive.ubuntu: Refreshing state...
sakuracloud_disk.main_disk: Refreshing state... (ID: 112900885329)
sakuracloud_server.main_server: Refreshing state... (ID: 112900885337)
sakuracloud_packet_filter.Rules: Destroying... (ID: 112900885360)
sakuracloud_packet_filter.Rules: Destruction complete
Error applying plan:

1 error(s) occurred:

* sakuracloud_packet_filter.Rules: sakuracloud_packet_filter.Rules: diffs didn't match during apply. This is a bug with Terraform and should be reported as a GitHub Issue.

Please include the following information in your report:

    Terraform Version: 0.9.9
    Resource ID: sakuracloud_packet_filter.Rules
    Mismatch reason: attribute mismatch: expressions.4.allow
    Diff One (usually from plan): *terraform.InstanceDiff{mu:sync.Mutex{state:0, sema:0x0}, Attributes:map[string]*terraform.ResourceAttrDiff{"expressions.3.allow":*terraform.ResourceAttrDiff{Old:"true", New:"false", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.2.allow":*terraform.ResourceAttrDiff{Old:"true", New:"true", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.4.allow":*terraform.ResourceAttrDiff{Old:"false", New:"true", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.0.source_nw":*terraform.ResourceAttrDiff{Old:"0.0.0.0/0", New:"0.0.0.0/0", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.1.allow":*terraform.ResourceAttrDiff{Old:"true", New:"true", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.2.source_nw":*terraform.ResourceAttrDiff{Old:"0.0.0.0/0", New:"0.0.0.0/0", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.4.protocol":*terraform.ResourceAttrDiff{Old:"ip", New:"", NewComputed:false, NewRemoved:true, NewExtra:interface {}(nil), RequiresNew:true, Sensitive:false, Type:0x0}, "expressions.3.source_nw":*terraform.ResourceAttrDiff{Old:"0.0.0.0/0", New:"0.0.0.0/0", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.0.description":*terraform.ResourceAttrDiff{Old:"Allow return tcp packet from all", New:"Allow return tcp packet from all", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.3.description":*terraform.ResourceAttrDiff{Old:"Allow fragment from all", New:"Deny from all", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.#":*terraform.ResourceAttrDiff{Old:"5", New:"4", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.4.source_nw":*terraform.ResourceAttrDiff{Old:"0.0.0.0/0", New:"", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.1.dest_port":*terraform.ResourceAttrDiff{Old:"32768-61000", New:"32768-61000", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "description":*terraform.ResourceAttrDiff{Old:"Sample Rules", New:"Sample Rules", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "zone":*terraform.ResourceAttrDiff{Old:"tk1a", New:"", NewComputed:true, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.0.dest_port":*terraform.ResourceAttrDiff{Old:"32768-61000", New:"32768-61000", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.2.protocol":*terraform.ResourceAttrDiff{Old:"icmp", New:"icmp", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "name":*terraform.ResourceAttrDiff{Old:"Rules", New:"Rules", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.2.description":*terraform.ResourceAttrDiff{Old:"Allow icmp from all", New:"Allow icmp from all", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.4.description":*terraform.ResourceAttrDiff{Old:"Deny from all", New:"", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.1.protocol":*terraform.ResourceAttrDiff{Old:"udp", New:"udp", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.3.protocol":*terraform.ResourceAttrDiff{Old:"fragment", New:"ip", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:true, Sensitive:false, Type:0x0}, "expressions.0.allow":*terraform.ResourceAttrDiff{Old:"true", New:"true", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.0.protocol":*terraform.ResourceAttrDiff{Old:"tcp", New:"tcp", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.1.description":*terraform.ResourceAttrDiff{Old:"Allow return udp packet from all", New:"Allow return udp packet from all", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.1.source_nw":*terraform.ResourceAttrDiff{Old:"0.0.0.0/0", New:"0.0.0.0/0", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}}, Destroy:false, DestroyDeposed:false, DestroyTainted:false, Meta:map[string]interface {}(nil)}
    Diff Two (usually from apply): *terraform.InstanceDiff{mu:sync.Mutex{state:0, sema:0x0}, Attributes:map[string]*terraform.ResourceAttrDiff{"expressions.3.source_nw":*terraform.ResourceAttrDiff{Old:"", New:"0.0.0.0/0", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.2.source_nw":*terraform.ResourceAttrDiff{Old:"", New:"0.0.0.0/0", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.0.source_nw":*terraform.ResourceAttrDiff{Old:"", New:"0.0.0.0/0", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.1.dest_port":*terraform.ResourceAttrDiff{Old:"", New:"32768-61000", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.3.allow":*terraform.ResourceAttrDiff{Old:"", New:"false", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.1.allow":*terraform.ResourceAttrDiff{Old:"", New:"true", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.2.description":*terraform.ResourceAttrDiff{Old:"", New:"Allow icmp from all", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "zone":*terraform.ResourceAttrDiff{Old:"", New:"", NewComputed:true, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:true, Sensitive:false, Type:0x0}, "expressions.0.allow":*terraform.ResourceAttrDiff{Old:"", New:"true", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.0.description":*terraform.ResourceAttrDiff{Old:"", New:"Allow return tcp packet from all", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "description":*terraform.ResourceAttrDiff{Old:"", New:"Sample Rules", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.1.source_nw":*terraform.ResourceAttrDiff{Old:"", New:"0.0.0.0/0", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.1.protocol":*terraform.ResourceAttrDiff{Old:"", New:"udp", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:true, Sensitive:false, Type:0x0}, "expressions.3.description":*terraform.ResourceAttrDiff{Old:"", New:"Deny from all", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.0.protocol":*terraform.ResourceAttrDiff{Old:"", New:"tcp", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:true, Sensitive:false, Type:0x0}, "expressions.3.protocol":*terraform.ResourceAttrDiff{Old:"", New:"ip", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:true, Sensitive:false, Type:0x0}, "name":*terraform.ResourceAttrDiff{Old:"", New:"Rules", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.1.description":*terraform.ResourceAttrDiff{Old:"", New:"Allow return udp packet from all", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.2.allow":*terraform.ResourceAttrDiff{Old:"", New:"true", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.0.dest_port":*terraform.ResourceAttrDiff{Old:"", New:"32768-61000", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "expressions.2.protocol":*terraform.ResourceAttrDiff{Old:"", New:"icmp", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:true, Sensitive:false, Type:0x0}, "expressions.#":*terraform.ResourceAttrDiff{Old:"", New:"4", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}}, Destroy:false, DestroyDeposed:false, DestroyTainted:false, Meta:map[string]interface {}(nil)}

Also include as much context as you can about your config, state, and the steps you performed to trigger this error.


Terraform does not automatically rollback in the face of errors.
Instead, your Terraform state file has been partially updated with
any resources that successfully completed. Please address the error
above and apply again to incrementally change your infrastructure.

$ # 使っていたパケットフィルタは消えてしまっていて、サーバのパケットフィルタも未割当
$ docker-compose run --rm terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

sakuracloud_ssh_key.setup_keypair: Refreshing state... (ID: 112900885327)
data.sakuracloud_archive.ubuntu: Refreshing state...
sakuracloud_disk.main_disk: Refreshing state... (ID: 112900885329)
sakuracloud_server.main_server: Refreshing state... (ID: 112900885337)
The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

+ sakuracloud_packet_filter.Rules
    description:               "Sample Rules"
    expressions.#:             "4"
    expressions.0.allow:       "true"
    expressions.0.description: "Allow return tcp packet from all"
    expressions.0.dest_port:   "32768-61000"
    expressions.0.protocol:    "tcp"
    expressions.0.source_nw:   "0.0.0.0/0"
    expressions.1.allow:       "true"
    expressions.1.description: "Allow return udp packet from all"
    expressions.1.dest_port:   "32768-61000"
    expressions.1.protocol:    "udp"
    expressions.1.source_nw:   "0.0.0.0/0"
    expressions.2.allow:       "true"
    expressions.2.description: "Allow icmp from all"
    expressions.2.protocol:    "icmp"
    expressions.2.source_nw:   "0.0.0.0/0"
    expressions.3.allow:       "false"
    expressions.3.description: "Deny from all"
    expressions.3.protocol:    "ip"
    expressions.3.source_nw:   "0.0.0.0/0"
    name:                      "Rules"
    zone:                      "<computed>"

~ sakuracloud_server.main_server
    packet_filter_ids.#: "0" => "<computed>"


Plan: 2 to add, 1 to change, 0 to destroy.

$ docker-compose run --rm terraform apply
data.sakuracloud_archive.ubuntu: Refreshing state...
sakuracloud_ssh_key.setup_keypair: Refreshing state... (ID: 112900885327)
sakuracloud_disk.main_disk: Refreshing state... (ID: 112900885329)
sakuracloud_server.main_server: Refreshing state... (ID: 112900885337)
sakuracloud_packet_filter.Rules: Creating...
  description:               "" => "Sample Rules"
  expressions.#:             "" => "4"
  expressions.0.allow:       "" => "true"
  expressions.0.description: "" => "Allow return tcp packet from all"
  expressions.0.dest_port:   "" => "32768-61000"
  expressions.0.protocol:    "" => "tcp"
  expressions.0.source_nw:   "" => "0.0.0.0/0"
  expressions.1.allow:       "" => "true"
  expressions.1.description: "" => "Allow return udp packet from all"
  expressions.1.dest_port:   "" => "32768-61000"
  expressions.1.protocol:    "" => "udp"
  expressions.1.source_nw:   "" => "0.0.0.0/0"
  expressions.2.allow:       "" => "true"
  expressions.2.description: "" => "Allow icmp from all"
  expressions.2.protocol:    "" => "icmp"
  expressions.2.source_nw:   "" => "0.0.0.0/0"
  expressions.3.allow:       "" => "false"
  expressions.3.description: "" => "Deny from all"
  expressions.3.protocol:    "" => "ip"
  expressions.3.source_nw:   "" => "0.0.0.0/0"
  name:                      "" => "Rules"
  zone:                      "" => "<computed>"
sakuracloud_packet_filter.Rules: Creation complete (ID: 112900885364)
sakuracloud_server.main_server: Modifying... (ID: 112900885337)
  packet_filter_ids.#: "0" => "1"
  packet_filter_ids.0: "" => "112900885364"
sakuracloud_server.main_server: Modifications complete (ID: 112900885337)

Apply complete! Resources: 1 added, 1 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path:

Outputs:

main_server = 27.133.XXX.XXX
```
