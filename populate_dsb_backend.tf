data "template_file" "dsb_populate" {
  template = file("${path.module}/templates/dsb_populate.sh.tpl")
  vars = {
    dsb_private_ip = oci_core_instance.ampere_a1.0.private_ip
  }
}

resource "null_resource" "populate_dsb_backend" {
  triggers = {
    instance_public_ip = oci_core_instance.ampere_a1.0.public_ip
    template_content = data.template_file.dsb_populate.rendered
  }
  connection {
    type        = "ssh"
    host        = oci_core_instance.ampere_a1.0.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.oci.private_key_pem
  }

  provisioner "file" {
    content = data.template_file.dsb_populate.rendered
    destination = "/home/ubuntu/dsb_populate.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x dsb_populate.sh",
      "/home/ubuntu/dsb_populate.sh"
    ]
  }
}
