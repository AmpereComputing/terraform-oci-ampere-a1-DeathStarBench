resource "null_resource" "build_wrk2" {
  triggers = {
    instance_public_ip = oci_core_instance.ampere_a1.0.public_ip
  }
  connection {
    type        = "ssh"
    host        = oci_core_instance.ampere_a1.0.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.oci.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "source build_lua_wrk2.sh",
      "DeathStarBench/socialNetwork/wrk2/wrk2 --help"
    ]
  }
}
