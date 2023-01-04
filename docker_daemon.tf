data "template_file" "docker_daemon_json" {
  template = file("${path.module}/templates/docker-daemon.json.tpl")
  vars = {
    public_ip = oci_core_instance.ampere_a1.0.public_ip
  }
}

output "docker_daemon_json" {
  value = data.template_file.docker_daemon_json.rendered
}

resource "local_file" "docker_daemon_json" {
  content = data.template_file.docker_daemon_json.rendered
  filename = "${path.module}/docker_registry-daemon.json"
}

data "template_file" "k3s_config_yaml" {
  template = file("${path.module}/templates/k3s_config.yaml.tpl")
  vars = {
    public_ip = oci_core_instance.ampere_a1.0.public_ip
    tf_random_id = random_uuid.random_id.result
  }
}

output "k3s_config_yaml" {
  value = data.template_file.k3s_config_yaml.rendered
}


resource "null_resource" "configure_docker" {
  triggers = {
    instance_public_ip = oci_core_instance.ampere_a1.0.public_ip
    template_content = data.template_file.docker_daemon_json.rendered
  }
  connection {
    type        = "ssh"
    host        = oci_core_instance.ampere_a1.0.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.oci.private_key_pem
  }

  provisioner "file" {
    content = data.template_file.docker_daemon_json.rendered
    destination = "/home/ubuntu/daemon.json"
  }

  provisioner "file" {
    content = data.template_file.k3s_config_yaml.rendered
    destination = "/home/ubuntu/k3s_config.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/rancher/k3s",
      "sudo mv /home/ubuntu/k3s_config.yaml /etc/rancher/k3s/config.yaml",
    ]
  }
}
