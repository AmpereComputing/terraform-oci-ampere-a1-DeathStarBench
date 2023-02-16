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
data "template_file" "run_wrk" {
  template = file("${path.module}/templates/run_wrk.sh.tpl")
  vars = {
    dsb_private_ip = oci_core_instance.ampere_a1.0.private_ip
    w_threads = var.wrk_number_of_threads
    w_conns = var.wrk_number_of_conns
    w_duration = var.wrk_duration
    w_rps = var.wrk_requests_per_second
  }
}


resource "null_resource" "execute_wrk" {
  triggers = {
    instance_public_ip = oci_core_instance.ampere_a1.1.public_ip
    template_content = data.template_file.dsb_populate.rendered
  }
  depends_on = [ null_resource.populate_dsb_backend ]
  connection {
    type        = "ssh"
    host        = oci_core_instance.ampere_a1.1.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.oci.private_key_pem
  }

  provisioner "file" {
    content = data.template_file.run_wrk.rendered
    destination = "/home/ubuntu/run_wrk.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x run_wrk.sh",
      "/home/ubuntu/run_wrk.sh"
    ]
  }
}
